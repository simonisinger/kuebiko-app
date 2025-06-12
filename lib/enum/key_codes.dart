final class AndroidTvKeys implements DeviceKeys {
  @override
  int keyUp = 19;
  @override
  int keyDown = 20;
  @override
  int keyLeft = 21;
  @override
  int keyRight = 22;
  @override
  int keyCenter = 23;
  @override
  int keyMediaStop = 86;
  @override
  int keyMenu = 82;
  @override
  int keyMediaPlayPause = 85;
  @override
  int keyMediaSkipForward = 272;
  @override
  int keyMediaStepForward = 90;
  @override
  int keyMediaStepBackward = 89;
  @override
  int keyBack = 4;

  AndroidTvKeys(this.value);
  final int value;
}

abstract interface class DeviceKeys {
  abstract int keyUp;
  abstract int keyDown;
  abstract int keyLeft;
  abstract int keyRight;
  abstract int keyCenter;
  abstract int keyMediaStop;
  abstract int keyMenu;
  abstract int keyMediaPlayPause;
  abstract int keyMediaSkipForward;
  abstract int keyMediaStepForward;
  abstract int keyMediaStepBackward;
  abstract int keyBack;
}

final class DesktopKeys implements DeviceKeys {
  @override
  int keyUp = 19;
  @override
  int keyDown = 20;
  @override
  int keyLeft = 21;
  @override
  int keyRight = 22;
  @override
  int keyCenter = 23;
  @override
  int keyMediaStop = 86;
  @override
  int keyMenu = 82;
  @override
  int keyMediaPlayPause = 85;
  @override
  int keyMediaSkipForward = 272;
  @override
  int keyMediaStepForward = 90;
  @override
  int keyMediaStepBackward = 89;
  @override
  int keyBack = 4;
  DesktopKeys(this.value);
  final int value;
}