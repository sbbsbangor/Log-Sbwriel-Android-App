// Log Sbwriel Android litter logging app for Processing.
// Copyright 2014 Snowdonia Society, SBBSBangor and Andrew Thomas.
// Based on previous code by Andrew Thomas (rights reserved).
// See accompanying license information.

import android.view.MotionEvent; 
import android.view.KeyEvent; 
import android.graphics.Bitmap; 
import java.io.*; 
import java.util.*;
import android.os.*; 
import android.content.*; 
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.view.*;
import android.content.res.*;


LocationManager locationManager;
MyLocationListener locationListener;
TextToSpeech tts;
float latitude=0,longitude=0,altitude=0,accuracy=0;
float scl=0,bw=0,bh=0,bm=0;
boolean setupDone=false,gpson=false,gotGPS=false;
boolean redraw=true,dospeech=true;
boolean ttsready=false,flog=true,ftime=true;
long gpstime=0,mtime;
int mode=0,bhigh=-1,iw=0,loggedvalue=0;
int language=0; // 0-Welsh 1-English
PImage icons[],img,satimg,splash,sbott;
int colrs[]={1,1,1,0,0,0,3,4,4,3,2,2};
String strs[],ltypes[];
String wstrs[]={  "Chwilio am loerennau",
                  "Trowch GPS ymlaen a cheisiwch unwaith eto",
                  "Cafwyd y lleoliad GPS",
                  "Statws GPS",
                  "Trowch GPS ymlaen!",
                  "Yn aros am ymateb..."};
String wltypes[]={"Potel blastig ddiod ysgafn",
                  "Potel wydr ddiod ysgafn",
                  "Can diod ysgafn",
                  "Potel blastig ddiod alcoholig",
                  "Potel wydr ddiod alcoholig",
                  "Can ddiod alcoholig",
                  "Eitem bwyd cyflym",
                  "Baw ci",
                  "Bag baw ci",
                  "Eitem ysmygu",
                  "Ffrwythau",
                  "Arall"};
String estrs[]={  "Looking for satellites",
                  "Turn on GPS and try again",
                  "Got GPS position",
                  "GPS Status",
                  "Turn on GPS!",
                  "Waiting for fix..."};
String eltypes[]={"Plastic bottle soft",
                  "Glass bottle soft",
                  "Drinks can soft",
                  "Plastic bottle alcohol",
                  "Glass bottle alcohol",
                  "Drinks can alcohol",
                  "Fast food item",
                  "Dog poo",
                  "Dog poo bag",
                  "Smoking item",
                  "Fruit",
                  "Other"};


void setup()
{
  int c;
  String ic;
  float sbscl,w,h;
  orientation(PORTRAIT);
  background(0,0,0);
  scl=float(width)/1280;
  bm=40*scl;
  bw=(float(width)-(4*bm))/3;
  bh=(float(height)-(5*bm))/4;
  iw=int(bw*0.75f);
  textSize(36*scl);
  try
  {
    File root=new File(Environment.getExternalStorageDirectory(),"Log sbwriel");
    if(!root.exists()) root.mkdirs();
  }
  catch(Exception e){};
  icons=new PImage[12];
  for(c=0;c<12;c++)
  {
    ic=""+c;
    if(language==1)
    if(c==0 || c==1 || c==3 || c==4)
      ic+="eng";
    icons[c]=loadImage("icon"+ic+".png");
    icons[c].resize(iw,iw);
    icons[c].loadPixels();
  }
  satimg=loadImage("satellite.png");
  satimg.resize(int(width*0.75f),int(width*0.75f));
  satimg.loadPixels();
  splash=loadImage("splash.png");
  splash.resize(int(width*0.9f),int(width*0.9f));
  splash.loadPixels();
  sbott=loadImage("splashbottom.png");
  sbscl=(float(width)*0.9f)/float(sbott.width);
  w=float(sbott.width)*sbscl;
  h=float(sbott.height)*sbscl;
  sbott.resize(int(w),int(h));
  sbott.loadPixels();
  switch(language)
  {
    case 0: // Welsh
            strs=wstrs;
            ltypes=wltypes;
            break;
    case 1: // English
            strs=estrs;
            ltypes=eltypes;
            break;
  }
  mtime=millis();
  setupDone=true;
}

void draw()
{
  String ic;
  if((millis()-gpstime)>10000 && gotGPS==true)
  {
    gotGPS=false;
    redraw=true;
  }
  if(redraw=true)
  {
    switch(mode)
    {
      case 0: // Splash screen mode
              drawsplashscreen();
              if((millis()-mtime)>4000)
              {
                mode=1;
                mtime=millis();
                ftime=true;
                redraw=true;
              }
              break;
      case 1: // No GPS mode
              if(ftime==true)
              {
                gpson=locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
                if(gpson==true) speak(strs[0]);
                else speak(strs[1]);
                ftime=false;
              }
              drawgpsstatus();
              if(gotGPS==true)
              {
                speak(strs[2]);
                mode=2;
                redraw=true;
              }
              if((millis()-mtime)>5000 && gpson==false)
              {
                System.exit(0);
              }
              break;
      case 2: // Log buttons mode
              drawbuttons();
              if(gotGPS==false)
              {
                mode=1;
                mtime=millis();
                ftime=true;
                redraw=true;
              }
              break;
      case 3: // Just logged mode
              if(ftime==true)
              {
                ic=""+loggedvalue;
                if(language==1)
                if(loggedvalue==0 || loggedvalue==1 || loggedvalue==3 || loggedvalue==4)
                  ic+="eng";
                ftime=false;
                img=loadImage("icon"+ic+".png");
                img.resize(int(width*0.75f),int(width*0.75f));
                img.loadPixels();
              }
              drawlogged();
              if((millis()-mtime)>1000)
              {
                mode=2;
                redraw=true;
              }
              break;
    }
  }
}
 
void drawsplashscreen()
{
  background(255,255,255);
  imageMode(CENTER);
  image(splash,width/2,(150*scl)+(splash.height/2));
  image(sbott,width/2,height-(150*scl)-(sbott.height/2));
 }
 
void drawgpsstatus()
{
  background(255,255,255);
  if(gpson==false)
  {
   stroke(134,23,23);
   fill(134,23,23);
  }
  else
  {
   stroke(24,118,29);
   fill(24,118,29);
  }
  strokeWeight(1);
  rect(50*scl,50*scl,width-100*scl,height-100*scl,50*scl);
  stroke(0,0,0);
  noFill();
  strokeWeight(10);
  rect(50*scl,50*scl,width-100*scl,height-100*scl,50*scl);
  imageMode(CENTER);
  image(satimg,width/2,height/2);
  stroke(255,255,255);
  fill(255,255,255);
  textAlign(CENTER,CENTER);
  textSize(170*scl);
  text(strs[3],width*0.5f,height*0.2f);
  textSize(100*scl);
  if(gpson==false)
  {
   text(strs[4],width*0.5f,height*0.8f);
  }
  else
  {
   text(strs[5],width*0.5f,height*0.8f);
  }
}
  
void drawlogged()
{
  background(255,255,255);
  switch(colrs[loggedvalue])
  {
    case 0: stroke(134,23,23);
            fill(134,23,23);
            break;
    case 1: stroke(24,118,29);
            fill(24,118,29);
            break;
    case 2: stroke(34,31,134);
            fill(34,31,134);
            break;
    case 3: stroke(152,155,5);
            fill(152,155,5);
            break;
   case 4:  stroke(196,21,209);
            fill(196,21,209);
            break;
  }
  strokeWeight(1);
  rect(50*scl,50*scl,width-100*scl,height-100*scl,50*scl);
  stroke(0,0,0);
  noFill();
  strokeWeight(10);
  rect(50*scl,50*scl,width-100*scl,height-100*scl,50*scl);
  imageMode(CENTER);
  image(img,width/2,height/2);
}
  
void drawbuttons()
{
  int c,d;
  background(255,255,255);
  for(c=0;c<3;c++)
  {
    for(d=0;d<4;d++)
    {
      switch(colrs[(d*3)+c])
      {
        case 0: stroke(134,23,23);
                fill(134,23,23);
                break;
        case 1: stroke(24,118,29);
                fill(24,118,29);
                break;
        case 2: stroke(34,31,134);
                fill(34,31,134);
                break;
        case 3: stroke(152,155,5);
                fill(152,155,5);
                break;
        case 4: stroke(196,21,209);
                fill(196,21,209);
                break;
      }
      strokeWeight(1);
      rect(((c+1)*bm)+(c*bw),((d+1)*bm)+(d*bh),bw,bh,20*scl);
      stroke(0,0,0);
      noFill();
      strokeWeight(5);
      rect(((c+1)*bm)+(c*bw),((d+1)*bm)+(d*bh),bw,bh,20*scl);
      if(((d*3)+c)==bhigh)
      {
        stroke(255,80,0);
        noFill();
        strokeWeight(20);
        rect(((c+1)*bm)+(c*bw),((d+1)*bm)+(d*bh),bw,bh,10*scl);
      }
      imageMode(CENTER);
      if(icons[(d*3)+c]!=null)
        image(icons[(d*3)+c],((c+1)*bm)+(c*bw)+(bw/2),((d+1)*bm)+(d*bh)+(bh/2));
    }
  }
  bhigh=-1;
}
  
int inbutton(float x,float y)
{
  int c,d;
  float ax,ay,bx,by;
  for(c=0;c<3;c++)
  {
    for(d=0;d<4;d++)
    {
      ax=((c+1)*bm)+(c*bw);
      ay=((d+1)*bm)+(d*bh);
      bx=ax+bw;
      by=ay+bh;
      if(x>=ax && x<=bx && y>=ay && y<=by)
      {
        return((d*3)+c);
      }
    }
  }
  return -1;
}
  
void mouseDown()
{
  int b;
  switch(mode)
  {
    case 2: b=inbutton(mouseX,mouseY);
            if(b!=bhigh)
            {
              bhigh=b;
              redraw=true;
            }
            break;
  }
}
  
void mouseDragged()
{
  int b;
  switch(mode)
  {
    case 2: b=inbutton(mouseX,mouseY);
            if(b!=bhigh)
            {
              bhigh=b;
              redraw=true;
            }
            break;
  }
}
    
void mouseReleased()
{
  int b;
  switch(mode)
  {
    case 2: b=inbutton(mouseX,mouseY);
            if(b!=-1)
            {
              addtolog(b);
              loggedvalue=b;
              mode=3;
              mtime=millis();
              ftime=true;
              redraw=true;
            }
            break;
  }
}

public void keyPressed()
{
  if(key==CODED)
  {
    if(keyCode==BACK)
    {
      if(setupDone)
      {
        System.exit(0);
      }
    }
    if(keyCode==MENU){}
    if(keyCode==KeyEvent.KEYCODE_SEARCH){}
    if(keyCode==KeyEvent.KEYCODE_HOME)
    {
      if(setupDone)
      {
        System.exit(0);
      }
    }
  }
}

public void addtolog(int logval)
{
  String fname=day()+"_"+month()+"_"+year()+".csv";
  try
  {
    File root=new File(Environment.getExternalStorageDirectory(),"Log sbwriel");
    File myfile=new File(root,fname);
    FileWriter writer=new FileWriter(myfile,true);
    // This format should hopefully work in Excel most of the time
    if(flog==true)
    {
      flog=false;
      writer.append("********** Log newydd / New log **********");
      writer.append("\r\n");
    }
    writer.append(latitude+",");
    writer.append(longitude+",");
    writer.append(logval+",");
    writer.append(year()+"-"+month()+"-"+day()+" "+hour()+":"+minute()+":"+second()+",");
    writer.append("\""+ltypes[logval]+"\",");
    writer.append((millis()-gpstime)+",");
    writer.append(altitude+",");
    writer.append(accuracy+"");
    writer.append("\r\n");
    writer.flush();
    writer.close();
    speak(ltypes[logval]);
  }
  catch(IOException e){}
}

void speak(String txt)
{
  if(ttsready==true && dospeech==true)
  {
    tts.setPitch(1.0f);
    tts.setSpeechRate(1.0f);
    tts.speak(txt,TextToSpeech.QUEUE_FLUSH,null);
  }
}
 
void onCreate(Bundle savedInstanceState)
{
  super.onCreate(savedInstanceState);
  tts=new TextToSpeech(this,new TextToSpeech.OnInitListener(){
    @Override public void onInit(int status)
    {
      if(status==0) ttsready=true;
    }});
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onConfigurationChanged(Configuration newConfig)
{
  super.onConfigurationChanged(newConfig);
}

void onActivityResult(int requestCode,int resultCode,Intent data)
{
}
 
void onDestroy()
{
  if (tts!=null)
  {
    tts.stop();
    tts.shutdown();
  }
  super.onDestroy();
}
 
void onResume()
{
  super.onResume();
  locationListener=new MyLocationListener();
  locationManager=(LocationManager)getSystemService(Context.LOCATION_SERVICE);
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,0,0,locationListener);
}

public void onPause()
{
  super.onPause();
}

class MyLocationListener implements LocationListener
{
  void onLocationChanged(Location location)
  {
    latitude=(float)location.getLatitude();
    longitude=(float)location.getLongitude();
    altitude=(float)location.getAltitude();
    accuracy=(float)location.getAccuracy();
    gpstime=millis();
    gotGPS=true;
  }

  void onProviderDisabled(String myprovider)
  { 
  }

  void onProviderEnabled(String myprovider)
  { 
  }

  void onStatusChanged(String myprovider,int status,Bundle extras)
  {
  }
}


