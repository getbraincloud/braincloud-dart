import 'dart:io';

void listDnsServers() async {
  final dnsServers = await getDnsServers();
  if (dnsServers.isNotEmpty) {
    print('DNS Servers: $dnsServers');
  } else {
    print('Unable to determine DNS servers.');
  }
}


Future<List<String>> getDnsServers() async {
  if (Platform.isLinux || Platform.isMacOS) {
    return await _getDnsServersFromResolvConf();
  } else if (Platform.isWindows) {
    return await _getDnsServersFromPowershell();
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}

Future<List<String>> _getDnsServersFromResolvConf() async {
  final file = File('/etc/resolv.conf');
  if (await file.exists()) {
    final content = await file.readAsString();
    return _extractDnsServersFromResolvConf(content);
  }
  return [];
}

List<String> _extractDnsServersFromResolvConf(String resolvConfContent) {
  final dnsServers = <String>[];
  final lines = resolvConfContent.split('\n');
  for (var line in lines) {
    if (line.startsWith('nameserver')) {
      final parts = line.split(' ');
      if (parts.length > 1) {
        dnsServers.add(parts[1]);
      }
    }
  }
  return dnsServers;
}

Future<List<String>> _getDnsServersFromPowershell() async {
  final result = await Process.run(
    'powershell',
    ['-Command', 'Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses'],
  );
  if (result.exitCode == 0) {
    final dnsServers = (result.stdout as String)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return dnsServers;
  } else {
    return [];
  }
}