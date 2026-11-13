# smi-deploy-targets: test
# A plain spec: no placeholders, the version comes from the %%{smi_version} macro the build
# defines. It goes to the test environment only and requires the common package, so it is
# handed over after it.
%global srcname smi-example-conf

Name:           smi-example-config-test
Version:        %{smi_version}
Release:        1
Summary:        Example configuration package, TEST machine

License:        MIT
URL:            https://setmy.info
Source0:        %{srcname}-%{version}.tar.gz

BuildArch:      noarch

Requires:       smi-example-config = %{version}-%{release}
Requires(post): sed

%description
What only the TEST machine has: conf.d/environment.conf. Its "# NB! TEST ONLY: "
lines are switched on when the package is installed, the way the nftables
configuration does it, so one file serves every machine.

%prep
%autosetup -n %{srcname}-%{version}

%build

%install
install -d -m 0755 %{buildroot}%{_sysconfdir}/smi-example/conf.d
install -m 0644 fedora/etc/smi-example/conf.d/environment.conf \
    %{buildroot}%{_sysconfdir}/smi-example/conf.d/environment.conf

%post
sed -i 's/^\( *\)# NB! TEST ONLY: /\1/' %{_sysconfdir}/smi-example/conf.d/environment.conf

%files
%config %{_sysconfdir}/smi-example/conf.d/environment.conf

%changelog
* Fri Nov 13 2026 Imre Tabur <imre.tabur@mail.ee> - 1.0.0-1
- Example package of a single environment
