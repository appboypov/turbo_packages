enum TDevice {
  androidCompact,
  androidMedium,
  iPhone16,
  iPhone16Pro,
  iPhone16ProMax,
  iPhone16Plus,
  iPhone14And15ProMax,
  iPhone14And15Pro,
  iPhone13And14,
  iPhone14Plus,
  iPhone13Mini,
  iPhoneSE,
  androidExpanded,
  surfacePro8,
  iPadMini,
  iPadPro11,
  iPadPro12_9,
  macBookAir,
  macBookPro14,
  macBookPro16,
  desktop,
  wireframe,
  tv,
  appleWatchSeries1042mm,
  appleWatchSeries1046mm,
  appleWatch41mm,
  appleWatch45mm,
  appleWatch44mm,
  appleWatch40mm,
  iPhone13ProMax,
  iPhone13AndPro,
  iPhone11ProMax,
  iPhone11ProAndX,
  iPhone8Plus,
  iPhone8,
  androidSmall,
  androidLarge,
  googlePixel2,
  googlePixel2XL,
  iPadMini5,
  surfacePro4,
  macBook,
  macBookPro,
  surfaceBook,
  appleWatch42mm,
  appleWatch38mm,
  iMac,
  macintosh128k;

  double get height {
    switch (this) {
      case TDevice.androidCompact:
        return 917;
      case TDevice.androidMedium:
        return 840;
      case TDevice.iPhone16:
        return 852;
      case TDevice.iPhone16Pro:
        return 874;
      case TDevice.iPhone16ProMax:
        return 956;
      case TDevice.iPhone16Plus:
        return 932;
      case TDevice.iPhone14And15ProMax:
        return 932;
      case TDevice.iPhone14And15Pro:
        return 852;
      case TDevice.iPhone13And14:
        return 844;
      case TDevice.iPhone14Plus:
        return 926;
      case TDevice.iPhone13Mini:
        return 812;
      case TDevice.iPhoneSE:
        return 568;
      case TDevice.androidExpanded:
        return 800;
      case TDevice.surfacePro8:
        return 960;
      case TDevice.iPadMini:
        return 1133;
      case TDevice.iPadPro11:
        return 1194;
      case TDevice.iPadPro12_9:
        return 1366;
      case TDevice.macBookAir:
        return 832;
      case TDevice.macBookPro14:
        return 982;
      case TDevice.macBookPro16:
        return 1117;
      case TDevice.desktop:
        return 1024;
      case TDevice.wireframe:
        return 1024;
      case TDevice.tv:
        return 720;
      case TDevice.appleWatchSeries1042mm:
        return 223;
      case TDevice.appleWatchSeries1046mm:
        return 248;
      case TDevice.appleWatch41mm:
        return 215;
      case TDevice.appleWatch45mm:
        return 242;
      case TDevice.appleWatch44mm:
        return 224;
      case TDevice.appleWatch40mm:
        return 197;
      case TDevice.iPhone13ProMax:
        return 926;
      case TDevice.iPhone13AndPro:
        return 844;
      case TDevice.iPhone11ProMax:
        return 896;
      case TDevice.iPhone11ProAndX:
        return 812;
      case TDevice.iPhone8Plus:
        return 736;
      case TDevice.iPhone8:
        return 667;
      case TDevice.androidSmall:
        return 640;
      case TDevice.androidLarge:
        return 800;
      case TDevice.googlePixel2:
        return 731;
      case TDevice.googlePixel2XL:
        return 823;
      case TDevice.iPadMini5:
        return 1024;
      case TDevice.surfacePro4:
        return 912;
      case TDevice.macBook:
        return 700;
      case TDevice.macBookPro:
        return 900;
      case TDevice.surfaceBook:
        return 1000;
      case TDevice.appleWatch42mm:
        return 195;
      case TDevice.appleWatch38mm:
        return 170;
      case TDevice.iMac:
        return 720;
      case TDevice.macintosh128k:
        return 342;
    }
  }

  double get width {
    switch (this) {
      case TDevice.androidCompact:
        return 412;
      case TDevice.androidMedium:
        return 700;
      case TDevice.iPhone16:
        return 393;
      case TDevice.iPhone16Pro:
        return 402;
      case TDevice.iPhone16ProMax:
        return 440;
      case TDevice.iPhone16Plus:
        return 430;
      case TDevice.iPhone14And15ProMax:
        return 430;
      case TDevice.iPhone14And15Pro:
        return 393;
      case TDevice.iPhone13And14:
        return 390;
      case TDevice.iPhone14Plus:
        return 428;
      case TDevice.iPhone13Mini:
        return 375;
      case TDevice.iPhoneSE:
        return 320;
      case TDevice.androidExpanded:
        return 1280;
      case TDevice.surfacePro8:
        return 1440;
      case TDevice.iPadMini:
        return 744;
      case TDevice.iPadPro11:
        return 834;
      case TDevice.iPadPro12_9:
        return 1024;
      case TDevice.macBookAir:
        return 1280;
      case TDevice.macBookPro14:
        return 1512;
      case TDevice.macBookPro16:
        return 1728;
      case TDevice.desktop:
        return 1440;
      case TDevice.wireframe:
        return 1440;
      case TDevice.tv:
        return 1280;
      case TDevice.appleWatchSeries1042mm:
        return 187;
      case TDevice.appleWatchSeries1046mm:
        return 208;
      case TDevice.appleWatch41mm:
        return 176;
      case TDevice.appleWatch45mm:
        return 198;
      case TDevice.appleWatch44mm:
        return 184;
      case TDevice.appleWatch40mm:
        return 162;
      case TDevice.iPhone13ProMax:
        return 428;
      case TDevice.iPhone13AndPro:
        return 390;
      case TDevice.iPhone11ProMax:
        return 414;
      case TDevice.iPhone11ProAndX:
        return 375;
      case TDevice.iPhone8Plus:
        return 414;
      case TDevice.iPhone8:
        return 375;
      case TDevice.androidSmall:
        return 360;
      case TDevice.androidLarge:
        return 360;
      case TDevice.googlePixel2:
        return 411;
      case TDevice.googlePixel2XL:
        return 411;
      case TDevice.iPadMini5:
        return 768;
      case TDevice.surfacePro4:
        return 1368;
      case TDevice.macBook:
        return 1152;
      case TDevice.macBookPro:
        return 1440;
      case TDevice.surfaceBook:
        return 1500;
      case TDevice.appleWatch42mm:
        return 156;
      case TDevice.appleWatch38mm:
        return 136;
      case TDevice.iMac:
        return 1280;
      case TDevice.macintosh128k:
        return 512;
    }
  }
}
