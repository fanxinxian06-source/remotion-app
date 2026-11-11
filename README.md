# ReMotion AI App 工程
## 平板（荣耀平板 / 安卓）
1. Android Studio：File > Open 选本文件夹，等待 Gradle 同步。
2. 平板开 USB 调试，点 Run；或 Build > Build APK(s)，文件在 app/build/outputs/apk/。
3. 首次联网使用姿态检测（需访问 jsDelivr 与 Google 模型存储），并允许摄像头权限。
## 手表（华为 WATCH 3 Pro）
DevEco Studio 新建 Wearable 工程，把 watch-deveco/Index.ets 放到 entry/src/main/ets/pages/ 后运行。
