import 'dart:convert';

class ApiUtils {
  static String modulesapiurl(bool emu) {
    if (emu) {
      return "http://10.0.2.2/rajpoot-foods/modules";
    } else {
      return "https://wamtsol.com/clients/rajput/modules";
    }
  }

  static String apiurl(bool emu) {
    if (emu) {
      return "http://10.0.2.2/rajpoot-foods";
    } else {
      return "https://wamtsol.com/clients/rajput";
    }
  }

  static String imageapiurl(bool emu) {
    if (emu) {
      return "${uploadsapiurl(true)}/item";
    } else {
      return "${uploadsapiurl(false)}/item";
    }
  }

  static String uploadsapiurl(bool emu) {
    if (emu) {
      return "http://10.0.2.2/rajpoot-foods/uploads";
    } else {
      return "https://wamtsol.com/clients/rajput/admin/uploads";
    }
  }

  static String uploadsapiurl2(bool emu) {
    if (emu) {
      return "http://10.0.2.2/rajpoot-foods/uploads";
    } else {
      return "https://wamtsol.com/clients/rajput/uploads";
    }
  }
}

class Encodedata {
  static String encodeid(String id) {
    final encoded = base64.encode(utf8.encode(id));
    return encoded;
  }

  static String decodeid(String encodedid) {
    final decoded = utf8.decode(base64.decode(encodedid));
    return decoded;
  }
}
