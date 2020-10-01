package com.share.flutterbackservice

import io.flutter.embedding.android.FlutterActivity
import android.widget.Toast
import android.content.Intent
import android.content.BroadcastReceiver
import android.content.Context
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.content.IntentFilter
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.plugin.common.BinaryMessenger
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.util.Log


class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler
{


    private var keepResult: MethodChannel.Result? = null;
    lateinit private  var myReceiver: MainActivity.MyReceiver;
    var serviceConnected:Boolean = false;

     var CHANNEL:String = "com.share.flutterbackservice/service";
     var capImagePath:String = "";

    override fun onCreate(savedInstanceState: Bundle?)
    {
        super.onCreate(savedInstanceState)
        MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(this::onMethodCall)
    }
    override fun onStart()
    {
        super.onStart()

        myReceiver = MyReceiver()
        val intentFilter = IntentFilter()
        intentFilter.addAction(DemoCamService.MY_ACTION)
        registerReceiver(myReceiver, intentFilter)
    }

    override fun onStop()
    {
        super.onStop()
        if (myReceiver != null) {
            unregisterReceiver(myReceiver);
        }
    }

    fun getFlutterView(): BinaryMessenger
    {
        return flutterEngine!!.dartExecutor.binaryMessenger
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result)
    {
        try {

            if (call.method.equals("connect")) {
                connectToService()
                keepResult = result
            } else if (serviceConnected) {
                if (call.method.equals("start")) {
                    val _data = capImagePath
                    result.success(_data)
                }
            } else {
                result.error(null, "App not connected to service", null)
            }
        } catch (e: Exception) {
            result.error(null, e.message, null)
        }

    }

    private fun connectToService()
    {
        if (!serviceConnected)
        {

            var service = Intent(this, SimpleService::class.java)
            startService(service)


            serviceConnected = true
        } else {
            if (keepResult != null)
            {
                keepResult!!.success(null)
                keepResult = null;
            }
        }
    }

    private inner class MyReceiver:BroadcastReceiver()
    {
       override fun onReceive(arg0: Context, arg1:Intent)
       {

           capImagePath = arg1.getStringExtra("path");
           Log.e("capImagePath",capImagePath);



       }
     }
}
