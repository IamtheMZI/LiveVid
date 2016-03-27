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
  if(count == 1000){
    count = 0;
  }
  if (cam.available() == true) {
    cam.read();
  }

  image(cam, 0, 0);
  String filename = "sketch_160325d\\"+count+".tif";
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
        URL oracle = new URL("http://192.168.0.114/videoshare.php?x="+data);
        BufferedReader in = new BufferedReader(
        new InputStreamReader(oracle.openStream()));
        in.close();
  } catch (Exception e){
    println(e);
  }
}

void file_upload(String filename) {
        URLConnection conn = null;
        OutputStream os = null;
        InputStream is = null;

        try {
            URL url = new URL("http://192.168.0.114/videoshareupload.php");
            System.out.println("url:" + url);
            conn = url.openConnection();
            conn.setDoOutput(true);

            String postData = "";

            InputStream imgIs = getClass().getResourceAsStream("/"+filename);
            byte[] imgData = new byte[imgIs.available()];
            imgIs.read(imgData);

            String message1 = "";
            message1 += "-----------------------------4664151417711" + CrLf;
            message1 += "Content-Disposition: form-data; name=\"uploadedfile\"; filename="+filename
                    + CrLf;
            message1 += "Content-Type: image/jpeg" + CrLf;
            message1 += CrLf;

            // the image is sent between the messages in the multipart message.

            String message2 = "";
            message2 += CrLf + "-----------------------------4664151417711--"
                    + CrLf;

            conn.setRequestProperty("Content-Type",
                    "multipart/form-data; boundary=---------------------------4664151417711");
            // might not need to specify the content-length when sending chunked
            // data.
            conn.setRequestProperty("Content-Length", String.valueOf((message1
                    .length() + message2.length() + imgData.length)));

            System.out.println("open os");
            os = conn.getOutputStream();

            System.out.println(message1);
            os.write(message1.getBytes());

            // SEND THE IMAGE
            int index = 0;
            int size = 1024;
            do {
                System.out.println("write:" + index);
                if ((index + size) > imgData.length) {
                    size = imgData.length - index;
                }
                os.write(imgData, index, size);
                index += size;
            } while (index < imgData.length);
            System.out.println("written:" + index);

            System.out.println(message2);
            os.write(message2.getBytes());
            os.flush();

            System.out.println("open is");
            is = conn.getInputStream();

            char buff = 512;
            int len;
            byte[] data = new byte[buff];
            do {
                System.out.println("READ");
                len = is.read(data);

                if (len > 0) {
                    System.out.println(new String(data, 0, len));
                }
            } while (len > 0);

            System.out.println("DONE");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            System.out.println("Close connection");
            try {
                os.close();
            } catch (Exception e) {
            }
            try {
                is.close();
            } catch (Exception e) {
            }
            try {

            } catch (Exception e) {
            }
        }
    }