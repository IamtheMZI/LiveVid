import processing.net.*;

int count = 1;
PImage img;
PImage previmg;
String lines[] ={""};
  
void setup(){
  size(640,480);
}

void draw(){
    int prev = millis();
  count = read_file(count);
  print(count+" ");
  //img = loadImage("192.168.0.114/upload/"+count+".tif");
  try{
  img = loadImage("http://"+Server.ip()+"/upload/"+count+".png");
  //img = loadImage(count+".tif");
  if(img != null)
  image(img, 0, 0);
  else
  image(previmg,0,0);
  }catch(Exception e){
    
  }

   int now = millis()-prev;
  println(now);
  int del = 100-now;
  previmg = img;
  
  if(del>0)
  delay(del);
  else
  delay(now);
}

int read_file(int currentframe){
 String[] co_ord={""};
 int x = currentframe;
 try{
 lines = loadStrings("http://"+Server.ip()+"/videoshare.txt");
 }catch(Exception e){
   
 }
  //  lines = loadStrings("C:\\Users\\UCSC_UAV\\Documents\\Processing\\workspace\\SketchPadServer\\Data.txt");
  if(lines.length >= 1){
    for(int inc=0; inc < lines.length; inc++){
    co_ord = split(lines[inc],' ');
    if(co_ord.length == 1){
        x = int(co_ord[0]);
    }
    } 
}
//println(x);
return x;

}