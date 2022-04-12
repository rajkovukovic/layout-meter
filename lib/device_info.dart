// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const encoder = JsonEncoder.withIndent('    ');

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({Key? key}) : super(key: key);

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String _deviceDataJson = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } catch (error) {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.\n$error'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = {
        'device': deviceData,
        'screen': _readScreenInfo(),
      };
      _deviceDataJson = encoder.convert(_deviceData);
    });
  }

  Map<String, dynamic> _readScreenInfo() {
    var pixelRatio = window.devicePixelRatio;

    //Size in physical pixels
    var physicalScreenSize = window.physicalSize;
    var physicalWidth = physicalScreenSize.width;
    var physicalHeight = physicalScreenSize.height;

//Size in logical pixels
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;

//Padding in physical pixels
    var padding = window.padding;

//Safe area paddings in logical pixels
    var paddingLeft = window.padding.left / window.devicePixelRatio;
    var paddingRight = window.padding.right / window.devicePixelRatio;
    var paddingTop = window.padding.top / window.devicePixelRatio;
    var paddingBottom = window.padding.bottom / window.devicePixelRatio;

//Safe area in logical pixels
    var safeWidth = logicalWidth - paddingLeft - paddingRight;
    var safeHeight = logicalHeight - paddingTop - paddingBottom;
    return {
      'pixelRatio': pixelRatio,
      'physicalScreenSize': physicalScreenSize.toString(),
      'physicalWidth': physicalWidth,
      'physicalHeight': physicalHeight,
      'logicalScreenSize': logicalScreenSize.toString(),
      'logicalWidth': logicalWidth,
      'logicalHeight': logicalHeight,
      'padding': padding.toString(),
      'paddingLeft': paddingLeft,
      'paddingRight': paddingRight,
      'paddingTop': paddingTop,
      'paddingBottom': paddingBottom,
      'safeWidth': safeWidth,
      'safeHeight': safeHeight,
    };
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            kIsWeb
                ? 'Web Browser info'
                : Platform.isAndroid
                    ? 'Android Device Info'
                    : Platform.isIOS
                        ? 'iOS Device Info'
                        : Platform.isLinux
                            ? 'Linux Device Info'
                            : Platform.isMacOS
                                ? 'MacOS Device Info'
                                : Platform.isWindows
                                    ? 'Windows Device Info'
                                    : '',
          ),
          actions: [
            IconButton(
                onPressed: initPlatformState, icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: _copyToClipboard, icon: const Icon(Icons.copy))
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(_deviceDataJson),
          )),
        ));
  }

  void _copyToClipboard() {
    String? error;
    Clipboard.setData(ClipboardData(text: _deviceDataJson)).onError((e, _) {
      error = e.toString();
    }).whenComplete(() {
      final snackBar = SnackBar(
        content: Text(error ?? 'Copied to clipboard'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
