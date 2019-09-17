# flutter_plugin_open_native

## 简介
完成了如果编写一个插件以及如何在Flutter中嵌入原生控件



### 插件
过程

#### 创建一个Flutter Plugin项目

#### 在native侧实现方法调用

#### 在Flutter侧进行调用

### Flutter嵌入原生控件
过程
#### 在Flutter侧
核心方法: android平台使用AndroidView，iOS平台使用UiKitView
``` dart
@override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'me.chunyu.textview/textview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }else if (defaultTargetPlatform == TargetPlatform.iOS){
      return UiKitView(
        viewType: 'me.chunyu.textview/textview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');

  }
```
#### 在native侧
两个核心类：
一个继承自`PlatformViewFactory` 的Factory类
一个实现了`PlatformView`和`MethodCallHandler`的View类

