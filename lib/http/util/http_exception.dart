/*
 * @Description: 
 * @Author: CoolSnow (coolsnow2020@gmail.com)
 * @Date: 2020-09-09 18:45:36
 * @LastEditors: CoolSnow
 * @LastEditTime: 2020-09-10 11:58:29
 */
class HttpException implements Exception {
  int code;
  String message;
  HttpException(this.code, this.message);
}
