package huangyuanlove.com.flutter_plugin_open_native;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/** FlutterPluginOpenNativePlugin */
public class FlutterPluginOpenNativePlugin implements MethodCallHandler {

  private Activity activity;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    registrar.platformViewRegistry().registerViewFactory("me.chunyu.textview/textview",new TextViewFactory(registrar.messenger()));
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin_open_native");
    channel.setMethodCallHandler(new FlutterPluginOpenNativePlugin(registrar.activity()));
  }

  public FlutterPluginOpenNativePlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("openOSView")){
      Intent intent = new Intent();
      intent.setAction(Intent.ACTION_VIEW);
      intent.setData(Uri.parse(call.arguments.toString()));
      activity.startActivity(intent);
    }
    else {
      result.notImplemented();
    }
  }
}


class TextViewFactory extends PlatformViewFactory{

  private final BinaryMessenger messenger;

  public TextViewFactory(BinaryMessenger messenger) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
  }

  @Override
  public PlatformView create(Context context, int id, Object o) {
    return new FlutterTextView(context, messenger, id);
  }

}

class FlutterTextView implements PlatformView, MethodCallHandler  {
  private final TextView textView;
  private final MethodChannel methodChannel;

  FlutterTextView(Context context, BinaryMessenger messenger, int id) {
    Log.e("id","id :-->" +id);
    textView = new TextView(context);
    textView.setTextColor(Color.BLUE);
    textView.setBackgroundColor(Color.GREEN);
    methodChannel = new MethodChannel(messenger, "me.chunyu.textview/textview");
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public View getView() {
    return textView;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
    switch (methodCall.method) {
      case "setText":
        setText(methodCall, result);
        break;
      default:
        result.notImplemented();
    }

  }

  private void setText(MethodCall methodCall, Result result) {
    String text = (String) methodCall.arguments;
    textView.setText(text);
    result.success(null);
  }

  @Override
  public void dispose() {}
}
