package bz.rxla.flutter_audiostream;

import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Handler;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodCall;
import java.io.IOException;

/**
 * FlutterAudiostreamPlugin
 */
public class FlutterAudiostreamPlugin implements MethodCallHandler {
  private final MethodChannel channel;
  private FlutterActivity activity;

  MediaPlayer mediaPlayer;

  public static FlutterAudiostreamPlugin register(FlutterActivity activity) {
    return new FlutterAudiostreamPlugin(activity);
  }

  private FlutterAudiostreamPlugin(FlutterActivity activity) {
    this.activity = activity;
    channel = new MethodChannel(activity.getFlutterView(), "flutter.rxla.bz/audio");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result response) {
    if (call.method.equals("play")) {
      Boolean resPlay = play(call.arguments.toString());
      response.success(1);
    } else if (call.method.equals("pause")) {
      pause();
      response.success(1);
    } else if (call.method.equals("stop")) {
      stop();
      response.success(1);
    } else {
      response.notImplemented();
    }
  }

  private void stop() {
    handler.removeCallbacks(sendData);
    mediaPlayer.stop();
    mediaPlayer.release();
    mediaPlayer = null;
  }

  private void pause() {
    mediaPlayer.pause();
    handler.removeCallbacks(sendData);
  }

  private Boolean play(String url) {
    if (mediaPlayer == null) {
      mediaPlayer = new MediaPlayer();
      mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

      try {
        mediaPlayer.setDataSource(url);
      } catch (IOException e) {
        e.printStackTrace();
        Log.d("AUDIO", "invalid DataSource");
      }

      try {
        mediaPlayer.prepare();
      } catch (IOException e) {
        Log.d("AUDIO", "media prepare ERROR");
        e.printStackTrace();
      }
    }

    channel.invokeMethod("audio.onDuration", mediaPlayer.getDuration());

    mediaPlayer.start();

    mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener(){
      @Override
      public void onCompletion(MediaPlayer mp) {
        stop();
        channel.invokeMethod("audio.onComplete", true);
      }
    });

    handler.post(sendData);

    return true;
  }

  final Handler handler = new Handler();

  private final Runnable sendData = new Runnable(){
    public void run(){
      try {
        if( ! mediaPlayer.isPlaying() ){
          handler.removeCallbacks(sendData);
        }
        int time = mediaPlayer.getCurrentPosition();
        channel.invokeMethod("audio.onCurrentPosition", time);

        handler.postDelayed(this, 200);
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  };

}