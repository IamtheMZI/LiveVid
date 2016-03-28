import processing.net.*;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;


int SOCKET_PORT = 12345;      // you may change this
String SERVER = Server.ip();  // localhost
String FILE_TO_RECEIVED = "C:\\xampp\\htdocs\\upload";  // you may change this, I give a
                                                            // different name because i don't want to
                                                            // overwrite the one used by server...
int FILE_SIZE = 6022386; // file size temporary hard coded

void draw () {
    int bytesRead;
    int current = 0;
    FileOutputStream fos = null;
    BufferedOutputStream bos = null;
    Socket sock = null;
    try {
      sock = new Socket(SERVER, SOCKET_PORT);
      System.out.println("Connecting...");

      // receive file
      byte [] mybytearray  = new byte [FILE_SIZE];
      InputStream is = sock.getInputStream();
       String[] lines = loadStrings("http://"+Server.ip()+"/videoshare.txt");
      fos = new FileOutputStream(FILE_TO_RECEIVED+"\\"+lines[0]+".png");
      bos = new BufferedOutputStream(fos);
      bytesRead = is.read(mybytearray,0,mybytearray.length);
      current = bytesRead;

      do {
         bytesRead =
            is.read(mybytearray, current, (mybytearray.length-current));
         if(bytesRead >= 0) current += bytesRead;
      } while(bytesRead > -1);

      bos.write(mybytearray, 0 , current);
      bos.flush();
      System.out.println("File " + FILE_TO_RECEIVED
          + " downloaded (" + current + " bytes read)");
    }catch(Exception e){
      
    }
      try{
      if (fos != null) fos.close();
      if (bos != null) bos.close();
      if (sock != null) sock.close();
      }catch(Exception e){
        
      }
  }