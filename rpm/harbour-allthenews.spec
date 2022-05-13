# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
#

Name:       harbour-allthenews

# >> macros
# << macros

Summary:    All the news. News from newapi.org.
Version:    0.2
Release:    1
Group:      Qt/Qt
License:    GPLv3
BuildArch:  noarch
URL:        https://github.com/poetaster/allthenews
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.3
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  librsvg-tools
BuildRequires:  qt5-qttools-linguist

%description
All the news. News from newapi.org. Requires an api key to use.

%if "%{?vendor}" == "chum"
PackageName: All the news
Type: desktop-application
Categories:
 - News
DeveloperName: Mark Washeim (poetaster)
Custom:
 - Repo: https://github.com/poetaster/allthenews
Icon: https://raw.githubusercontent.com/poetaster/allthenews/master/icons/172x172/harbour-allthenews.png
Screenshots:
 - https://raw.githubusercontent.com/poetaster/allthenews/master/Screenshot_1.png
 - https://raw.githubusercontent.com/poetaster/allthenews/master/Screenshot_2.png
 - https://raw.githubusercontent.com/poetaster/allthenews/master/Screenshot_3.png
Url:
  Donation: https://www.paypal.me/poetasterFOSS
%endif

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%defattr(0644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files
