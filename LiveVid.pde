import processing.net.*;
import java.net.HttpURLConnection;
import java.io.*;
import java.net.*;
import processing.video.*;

String CrLf = "\r\n";
Capture cam;
String list[]={""};
String str="";
int count = 0;

  FileInputStream fis = null;
    BufferedInputStream bis = null;
    OutputStream os = null;
    ServerSocket servsock = null;
    Socket sock = null;
    
void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void draw() {
    int prev = millis();
  count++;
  if(count == 10){
    count = 0;
  }
  if (cam.available() == true) {
    cam.read();
  }

  image(cam, 0, 0);
  String filename = "C:\\Users\\UCSC_UAV\\Documents\\Processing\\workspace\\LiveVid\\sketch_160325d\\"+count+".png";
  save(filename);
  file_upload(filename);
  write_file(count);
  
  //println(now);
  int now = millis()-prev;
  int del = 90 - now;
  if(del>0)
  delay(del);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void write_file(int data){
  try{
    println(data);
        URL oracle = new URL("http://"+Server.ip()+"/videoshare.php?x="+data);
        BufferedReader in = new BufferedReader(
        new InputStreamReader(oracle.openStream()));
        in.close();
  } catch (Exception e){
    println(e);
  }
}

void file_upload(String FILE_TO_SEND){

    try {
      servsock = new ServerSocket(12345);
     // while (true) 
      {
        System.out.println("Waiting...");
        try {
          sock = servsock.accept();
          System.out.println("Accepted connection : " + sock);
          // send file
          File myFile = new File (FILE_TO_SEND);
          byte [] mybytearray  = new byte [(int)myFile.length()];
          fis = new FileInputStream(myFile);
          bis = new BufferedInputStream(fis);
          bis.read(mybytearray,0,mybytearray.length);
          os = sock.getOutputStream();
          System.out.println("Sending " + FILE_TO_SEND + "(" + mybytearray.length + " bytes)");
          os.write(mybytearray,0,mybytearray.length);
          os.flush();
          System.out.println("Done.");
        }
        finally {
          if (bis != null) bis.close();
          if (os != null) os.close();
          if (sock!=null) sock.close();
        }
      }
    }catch(Exception e){
      
    }
    finally {
      try{
      if (servsock != null) servsock.close();
      }catch(Exception e){
        
      }
    }
}