
import 'dart:io';

class PostFile
{
  File file;
  String viewType;
  bool isUploaded= false;
  String captureTime;
  String serverUrl;
  PostFile({this.file,this.viewType,this.isUploaded,this.serverUrl,this.captureTime});
}