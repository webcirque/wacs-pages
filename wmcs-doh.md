# public-resolvers

This is an extensive list of public DNS resolvers supporting the
DNS-over-HTTP2 protocols.

This list is maintained by Frank Denis <webcirque @ gmail [.] com>

Warning: it includes servers that may censor content and servers that don't
verify DNSSEC records.

Adjust the `require_*` options in dnscrypt-proxy to filter that list
according to your needs.

To use this list, add this to the `[sources]` section of your
`dnscrypt-proxy.toml` configuration file:

    [sources.'public-resolvers']
    urls = ['https://www.wacs.ink/wmcs-doh.md', 'https://www.wmcs.pw/wmcs-doh.md', 'https://webcirque.github.io/wacs-pages/wmcs-doh.md']
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    cache_file = 'wmcs-doh.md'

--


## WACS Singaporean DoH Server

Non-logging and non-profit DoH server in the Singapore, operated by Project Webcirque.

https://www.pwcq.dev/disclaimer/doh/

sdns://AgcAAAAAAAAADjE5NS4xMjMuMjM5LjgyAA9yaS53YWNzLmluazo0NDMML2Rucy9yZXNvbHZk
