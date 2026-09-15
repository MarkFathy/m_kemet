import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
class DocumentFilterHelper {
  DocumentFilterHelper._();

  static Future<String> processCamScannerImage(String inputPath) async {
    try {
      return await compute(_processCamScannerImageInternal, inputPath);
    } catch (_) {
      return _processCamScannerImageInternal(inputPath);
    }
  }

  static String _processCamScannerImageInternal(String inputPath) {
    try {
      final inputFile = File(inputPath);
      if (!inputFile.existsSync()) return inputPath;

      final bytes = inputFile.readAsBytesSync();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return inputPath;

      // 1. Downscale if very large for fast processing
      const maxDim = 1800;
      img.Image src = decoded;
      if (src.width > maxDim || src.height > maxDim) {
        src = src.width > src.height
            ? img.copyResize(src, width: maxDim)
            : img.copyResize(src, height: maxDim);
      }

      final width = src.width;
      final height = src.height;

      // 2. Downsample to small grid for fast background illumination estimation
      const smallW = 120;
      final smallH = math.max(1, (height * (smallW / width)).round());
      final small = img.copyResize(src, width: smallW, height: smallH);

      // Compute grayscale luminance on small grid
      final smallLums = Float32List(smallW * smallH);
      for (int y = 0; y < smallH; y++) {
        for (int x = 0; x < smallW; x++) {
          final p = small.getPixel(x, y);
          smallLums[y * smallW + x] = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
        }
      }

      // 3. Dilation (5x5 max filter) on small grid to remove dark text
      final dilated = Float32List(smallW * smallH);
      for (int y = 0; y < smallH; y++) {
        for (int x = 0; x < smallW; x++) {
          double maxVal = 0.0;
          for (int dy = -2; dy <= 2; dy++) {
            final ny = (y + dy).clamp(0, smallH - 1);
            for (int dx = -2; dx <= 2; dx++) {
              final nx = (x + dx).clamp(0, smallW - 1);
              final v = smallLums[ny * smallW + nx];
              if (v > maxVal) maxVal = v;
            }
          }
          dilated[y * smallW + x] = maxVal;
        }
      }

      // 4. Box blur (5x5) on small grid to get smooth background illumination
      final bgSmall = Float32List(smallW * smallH);
      for (int y = 0; y < smallH; y++) {
        for (int x = 0; x < smallW; x++) {
          double sum = 0.0;
          int count = 0;
          for (int dy = -2; dy <= 2; dy++) {
            final ny = y + dy;
            if (ny < 0 || ny >= smallH) continue;
            for (int dx = -2; dx <= 2; dx++) {
              final nx = x + dx;
              if (nx < 0 || nx >= smallW) continue;
              sum += dilated[ny * smallW + nx];
              count++;
            }
          }
          bgSmall[y * smallW + x] = count > 0 ? (sum / count) : 1.0;
        }
      }

      // Bilinear background sampling
      double sampleBg(double fx, double fy) {
        final gx = (fx * (smallW - 1)).clamp(0.0, smallW - 1.0);
        final gy = (fy * (smallH - 1)).clamp(0.0, smallH - 1.0);
        final x0 = gx.floor();
        final y0 = gy.floor();
        final x1 = math.min(x0 + 1, smallW - 1);
        final y1 = math.min(y0 + 1, smallH - 1);
        final dx = gx - x0;
        final dy = gy - y0;

        final v00 = bgSmall[y0 * smallW + x0];
        final v10 = bgSmall[y0 * smallW + x1];
        final v01 = bgSmall[y1 * smallW + x0];
        final v11 = bgSmall[y1 * smallW + x1];

        final top = v00 * (1.0 - dx) + v10 * dx;
        final bottom = v01 * (1.0 - dx) + v11 * dx;
        return top * (1.0 - dy) + bottom * dy;
      }

      // 5. Sample histogram to find p_low (1st percentile) and p_high (88th percentile)
      final hist = Int32List(256);
      int sampledCount = 0;
      for (int y = 0; y < height; y += 2) {
        final fy = y / (height - 1);
        for (int x = 0; x < width; x += 2) {
          final fx = x / (width - 1);
          final p = src.getPixel(x, y);
          final Y = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
          final bg = math.max(1.0, sampleBg(fx, fy));
          final yNorm = ((Y / bg) * 255.0).clamp(0.0, 255.0).round();
          hist[yNorm]++;
          sampledCount++;
        }
      }

      final targetLow = (sampledCount * 0.01).round();
      final targetHigh = (sampledCount * 0.88).round();

      int cum = 0;
      double pLow = 10.0;
      double pHigh = 220.0;
      bool foundLow = false;

      for (int i = 0; i < 256; i++) {
        cum += hist[i];
        if (!foundLow && cum >= targetLow) {
          pLow = i.toDouble();
          foundLow = true;
        }
        if (cum >= targetHigh) {
          pHigh = math.max(pLow + 1.0, i.toDouble());
          break;
        }
      }

      final range = pHigh - pLow;

      // 6. Apply illumination division & contrast stretch with full color preservation
      final out = img.Image(width: width, height: height);
      for (int y = 0; y < height; y++) {
        final fy = y / (height - 1);
        for (int x = 0; x < width; x++) {
          final fx = x / (width - 1);
          final p = src.getPixel(x, y);
          final r = p.r.toDouble();
          final g = p.g.toDouble();
          final b = p.b.toDouble();
          final Y = 0.299 * r + 0.587 * g + 0.114 * b;

          final bg = math.max(1.0, sampleBg(fx, fy));
          final yNorm = (Y / bg) * 255.0;
          final yStretched = ((yNorm - pLow) / range * 255.0).clamp(0.0, 255.0);

          final scale = yStretched / math.max(1.0, Y);

          final newR = (r * scale).clamp(0.0, 255.0).round();
          final newG = (g * scale).clamp(0.0, 255.0).round();
          final newB = (b * scale).clamp(0.0, 255.0).round();

          out.setPixelRgb(x, y, newR, newG, newB);
        }
      }

      final encoded = img.encodeJpg(out, quality: 92);
      final outPath = inputPath.replaceAll(RegExp(r'\.[^.]+$'), '_enhanced.jpg');
      File(outPath).writeAsBytesSync(encoded);
      return outPath;
    } catch (_) {
      return inputPath;
    }
  }
}
