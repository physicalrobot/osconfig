# dev-packages.nix
{ pkgs }: 
with pkgs; [
  node2nix
  nodejs
  pnpm
  yarn
  nodePackages.prettier
  git
  typos
  ruby
  gcc
  python3
  python3Packages.pip
  python3Packages.virtualenv
  python3Packages.wheel
  python3Packages.setuptools
  postgresql
  postgresql_13
  libxslt
  libzip
  openldap
  cyrus_sasl
  libxml2
  libjpeg
  wget
  wkhtmltopdf
  (sassc.override { libsass = libsass; })
  libev
  zlib
  python312Packages.pip
  python312Packages.virtualenv
  python312Packages.cython
  python312Packages.psycopg2
  python312Packages.python-ldap
  openjdk17
]

