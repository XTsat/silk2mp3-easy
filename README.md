# silk2mp3-easy

方便快速的将silk语音文件转换为MP3格式

---

在找silk转mp3格式工具的时候，发现了很多转换项目，但是这些软件都需要命令行或者客户端使用，对于经常使用来说会很麻烦，所以我自己写了一个bat脚本来实现这些功能，方便快速将语音转换为mp3。

## 快速使用

- 下载完整版，将音频文件拖入脚本自动转换为mp3
- 下载无依赖版，将依赖软件和脚本放在一起，将音频文件拖入脚本自动转换为mp3
- 下载一键安装脚本，一键安装最新版(需要良好的github网络)

- 单文件脚本主要是方便测试脚本及依赖是否可用，输出文件还在源目录
- 多文件脚本则会将源文件移动到本目录，转换文件放在导出目录

### 文件依赖

如果没有依赖可以使用 `一键安装脚本.bat`，或者手动选择需要的依赖下载

- silk-decoder
  - [foyoux / silk-codec](https://github.com/foyoux/silk-codec/releases)
  - [kn007 / silk-v3-decoder](https://github.com/kn007/silk-v3-decoder/blob/master/windows/silk_v3_decoder.exe)
- ffmpeg
  - [BtbN / FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds/releases)
  - [gyan.dev / FFmpeg-Builds](https://www.gyan.dev/ffmpeg/builds/)
