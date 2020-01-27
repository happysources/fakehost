#!/usr/bin/python3

HOSTS = '/etc/hosts'
DEBUG = 1

def fakehost(host='', ip='127.0.0.1'):
	""" fake dns record in local /etc/host """

	replace = 0

	lines = []
	for line in open(HOSTS, 'r').read().split('\n'):
		_lines = line.split()

		if len(_lines) < 2:
			lines.append(line)
			continue

		_ip = _lines[0]

		if ip != _ip:
			lines.append(line)
			continue
		
		# host is exist for ip
		if host in _lines[1:]:
			if DEBUG:
				print('exist hostname="%s" for exist ip="%s"' % (host, ip))
			return True


		# add host for exist ip
		_lines.append(host)
		lines.append(' '.join(_lines))
		replace = 1
		if DEBUG:
			print('add hostname="%s" for exist ip="%s"' % (host, ip))


	if replace == 0:
		# add host for ip
		lines.append('%s\t%s' % (ip, host))
		if DEBUG:
			print('add hostname="%s" for new ip="%s"' % (host, ip))

	lines.append('')

	# /etc/host saved
	open(HOSTS, 'w').write('\n'.join(lines))

	return True


if __name__ == '__main__':

	import sys

	print(sys.argv)
	if len(sys.argv) == 2:
		fakehost(sys.argv[1])
	elif len(sys.argv) == 3:
		fakehost(sys.argv[1], sys.argv[2])
	else:
		print('Example: $ fakehost new-hostname 127.0.0.1')
