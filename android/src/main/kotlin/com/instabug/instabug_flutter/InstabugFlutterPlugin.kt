package com.instabug.instabug_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.app.Application
import android.content.Context
import androidx.annotation.NonNull
import com.instabug.chat.Replies
import com.instabug.library.Instabug
import com.instabug.library.InstabugColorTheme
import com.instabug.library.invocation.InstabugInvocationEvent
import com.instabug.library.ui.onboarding.WelcomeMessage
import java.util.*

/** InstabugFlutterPlugin */
class InstabugFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.instabug/instabug")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "start" -> {
                val args = call.arguments as List<Any>
                val token = args[0] as String

                val builder = Instabug.Builder(context as Application, token)
                if (args.contains("none")) {
                    builder.setInvocationEvents(InstabugInvocationEvent.NONE)
                }
                if (args.contains("shake")) {
                    builder.setInvocationEvents(InstabugInvocationEvent.SHAKE)
                }
                if (args.contains("floatingButton")) {
                    builder.setInvocationEvents(InstabugInvocationEvent.FLOATING_BUTTON)
                }
                if (args.contains("screenshot")) {
                    builder.setInvocationEvents(InstabugInvocationEvent.SCREENSHOT)
                }
                if (args.contains("twoFingerSwipeLeft")) {
                    builder.setInvocationEvents(InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT)
                }
                builder.build()
                result.success(null)
            }
            "setWelcomeMessageMode" -> {
                when (call.arguments as String) {
                    "live" -> Instabug.setWelcomeMessageState(WelcomeMessage.State.LIVE)
                    "beta" -> Instabug.setWelcomeMessageState(WelcomeMessage.State.BETA)
                    "disabled" -> Instabug.setWelcomeMessageState(WelcomeMessage.State.DISABLED)
                }
                result.success(null)
            }
            "showWelcomeMessage" -> {
                when (call.arguments as String) {
                    "live" -> Instabug.showWelcomeMessage(WelcomeMessage.State.LIVE)
                    "beta" -> Instabug.showWelcomeMessage(WelcomeMessage.State.BETA)
                    "disabled" -> Instabug.showWelcomeMessage(WelcomeMessage.State.DISABLED)
                }
                result.success(null)
            }
            "identifyUser" -> {
                val args = call.arguments as List<String?>
                val name = args[0] ?: ""
                val email = args[1] ?: ""
                Instabug.identifyUser(name, email)
                result.success(null)
            }
            "setBrightness" -> {
                when (call.arguments as String) {
                    "dark" -> Instabug.setColorTheme(InstabugColorTheme.InstabugColorThemeDark)
                    "light" -> Instabug.setColorTheme(InstabugColorTheme.InstabugColorThemeLight)
                }

                result.success(null)
            }
            "setPrimaryColor" -> {
                Instabug.setPrimaryColor((call.arguments as Long).toInt())
                result.success(null)
            }
            "logOut" -> {
                Instabug.logoutUser()
                result.success(null)
            }
            "setInAppNotificationEnabled" -> {
                Replies.setInAppNotificationEnabled(call.arguments as Boolean)
                result.success(null)
            }
            "setLocale" -> {
                val parts = call.arguments as List<String>
                Instabug.setLocale(Locale(parts[0], parts[1], parts[2]))
                result.success(null)
            }
            "show" -> {
                Instabug.show()
                result.success(null)
            }
            "replies" -> {
                Replies.show()
                result.success(null)
            }
            "hasChats" -> {
                result.success(Replies.hasChats())
            }
            "getUnreadRepliesCount" -> {
                result.success(Replies.getUnreadRepliesCount())
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
