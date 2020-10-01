package com.share.flutterbackservice;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;



public class SimpleService extends Service
{

    private int _currentValue;
    private boolean stopService = true;

    public SimpleService() {
    }
 
    @Override
    public IBinder onBind(Intent intent)
    {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId)
    {

        MyThread myThread = new MyThread();
        myThread.start();
        return super.onStartCommand(intent, flags, startId);
    }



    public class MyThread extends Thread{
        @Override
        public void run() {
            while (stopService)
            {
                try {
                    Thread.sleep(30000);

                    startService(new Intent(getApplicationContext(), DemoCamService.class));

                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            stopSelf();
        }
    }
}
