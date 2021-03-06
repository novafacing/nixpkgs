{ stdenv
, fetchurl
, meson
, ninja
, wrapGAppsHook
, pkgconfig
, gettext
, itstool
, libvirt-glib
, glib
, gobject-introspection
, libxml2
, gtk3
, gtk-vnc
, freerdp
, libvirt
, spice-gtk
, python3
, spice-protocol
, libsoup
, libosinfo
, systemd
, tracker
, tracker-miners
, vala
, libcap
, yajl
, gmp
, gdbm
, cyrus_sasl
, gnome3
, librsvg
, desktop-file-utils
, mtools
, cdrkit
, libcdio
, libusb1
, libarchive
, acl
, libgudev
, libsecret
, libcap_ng
, numactl
, xen
, libapparmor
, json-glib
, webkitgtk
, vte
, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "gnome-boxes";
  version = "3.36.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0c3cw90xqqcpacc2z06ljs0gg8saxizfgjzg9alhpwgz3gl4c5pg";
  };

  doCheck = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    itstool
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = [
    spice-gtk
  ];

  buildInputs = [
    acl
    cyrus_sasl
    freerdp
    gdbm
    glib
    glib-networking
    gmp
    gnome3.adwaita-icon-theme
    gtk-vnc
    gtk3
    json-glib
    libapparmor
    libarchive
    libcap
    libcap_ng
    libgudev
    libosinfo
    librsvg
    libsecret
    libsoup
    libusb1
    libvirt
    libvirt-glib
    libxml2
    numactl
    spice-gtk
    spice-protocol
    systemd
    tracker
    tracker-miners
    vte
    webkitgtk
    xen
    yajl
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ mtools cdrkit libcdio ]}")
  '';

  postPatch = ''
    chmod +x build-aux/post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = "https://wiki.gnome.org/Apps/Boxes";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
