# Hnuter QGC 使用说明

## 构建

推荐使用仓库内 Docker 构建环境：

```sh
bash deploy/docker/docker-run.sh --fuse qgc-ubuntu-docker Debug
```

构建产物：

- `build/Debug/QGroundControl`
- `build/QGroundControl-x86_64.AppImage`

如果 AppImage 打包提示 `Text file busy`，通常是旧的 QGroundControl AppImage 仍在运行或 FUSE 挂载未释放。关闭旧 QGC 后重新构建即可。

## Hnuter 4051 机型

QGC 已内置 `Hnuter T Tiltrotor` 机型项，`SYS_AUTOSTART=4051` 时会显示 T 构型示意图。

PX4 侧建议在 4051 airframe 脚本中给一级倾转参数设置默认值，QGC 才能在进入 Actuators 页面时直接显示电机与一级/二级倾转舵机的关系：

```sh
param set-default CA_ROTOR0_TILT 1
param set-default CA_ROTOR1_TILT 1
param set-default CA_ROTOR2_TILT 2
param set-default CA_ROTOR3_TILT 2
param set-default CA_ROTOR4_TILT 0
```

QGC 的 `Tilted by` 列现在显示两行：

- `1`: 原始 `CA_ROTORx_TILT` 一级倾转配置。
- `2`: 二级倾转显示。若固件没有二级参数，则按 `CA_SV_TL_COUNT=4` 派生：`Tilt 1 -> Tilt 3`，`Tilt 2 -> Tilt 4`。

## 固件版本

PX4 的 `flight_custom_version` 表示 Git hash，不是语义化版本号。机架 Summary 页面现在显示：

- `Firmware Version`: 来自 MAVLink `AUTOPILOT_VERSION.flight_sw_version`。
- `Git Hash`: 来自 MAVLink `AUTOPILOT_VERSION.flight_custom_version`。

这样不会再把 PX4 custom version 误显示为 `0.0.0`。

## Fly 页面舵机状态

Fly 主页面右下角增加 `Servos` 状态面板，显示 MAVLink `SERVO_OUTPUT_RAW` 中的舵机 PWM。4051 常用的 AUX1-AUX4 会显示为 `S1` 到 `S4`。

如果看不到数值，请确认固件正在发布 `SERVO_OUTPUT_RAW`，并且当前连接不是高延迟链路或日志回放模式。
