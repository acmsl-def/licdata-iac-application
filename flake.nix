# flake.nix
#
# This file packages licdata-iac-application as a Nix flake.
#
# Copyright (C) 2024-today acm-sl's licdata-iac-application
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Nix flake for acmsl/licdata-iac-application";
  inputs = rec {
    acmsl-licdata-artifact-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events/0.0.11";
    };
    acmsl-licdata-iac-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-iac-domain/0.0.16";
    };
    acmsl-licdata-iac-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.acmsl-licdata-iac-domain.follows = "acmsl-licdata-iac-domain";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-iac-infrastructure/0.0.5";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-artifact-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-artifact-def/infrastructure/0.0.69";
    };
    pythoneda-shared-iac-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/events/0.0.7";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.71";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.92";
    };
    pythoneda-shared-pythonlang-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-def/application/0.0.90";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-iac-application";
        version = "0.0.3";
        sha256 = "1vlbxkcnrcpib9pv7nvqn4z1cyp83p4bzw1hbbzl8apjf9z4zyk3";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.iac.licdata.application";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixos { inherit system; };
        description = "Licdata IaC";
        entrypoint = "licdata_iac_app";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "I";
        layer = "A";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        acmsl-licdata-application-for = {
            acmsl-licdata-artifact-events
          , acmsl-licdata-iac-domain
          , acmsl-licdata-iac-infrastructure
          , python
          , pythoneda-shared-artifact-infrastructure
          , pythoneda-shared-iac-events, pythoneda-shared-pythonlang-banner
          , pythoneda-shared-pythonlang-domain
          , pythoneda-shared-pythonlang-application }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
            banner_file = "${package}/licdata_iac_banner.py";
            banner_class = "LicdataIacBanner";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTomlTemplate = ./templates/pyproject.toml.template;
            pyprojectToml = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion pythonpackage
                version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              acmslLicdataArtifactEvents =
                acmsl-licdata-artifact-events.version;
              acmslLicdataIacDomain = acmsl-licdata-iac-domain.version;
              acmslLicdataIacInfrastructure = acmsl-licdata-iac-infrastructure.version;
              pythonedaSharedArtifactInfrastructure = pythoneda-shared-artifact-infrastructure.version;
              pythonedaSharedIacEvents = pythoneda-shared-iac-events.version;
              pythonedaSharedPythonlangBanner =
                pythoneda-shared-pythonlang-banner.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
              pythonedaSharedPythonlangApplication =
                pythoneda-shared-pythonlang-application.version;
              src = pyprojectTomlTemplate;
            };
            bannerPyTemplate = ./templates/banner.py.template;
            bannerPy = pkgs.substituteAll {
              project_name = pname;
              file_path = banner_file;
              inherit banner_class org repo;
              tag = version;
              pescio_space = space;
              arch_role = archRole;
              hexagonal_layer = layer;
              python_version = pythonMajorMinorVersion;
              nixpkgs_release = nixpkgsRelease;
              src = bannerPyTemplate;
            };

            entrypointShTemplate =
              "${pythoneda-shared-pythonlang-banner}/templates/entrypoint.sh.template";
            entrypointSh = pkgs.substituteAll {
              arch_role = archRole;
              hexagonal_layer = layer;
              nixpkgs_release = nixpkgsRelease;
              inherit homepage maintainers org python repo version;
              pescio_space = space;
              python_version = pythonMajorMinorVersion;
              pythoneda_shared_pythoneda_banner =
                pythoneda-shared-pythonlang-banner;
              pythoneda_shared_pythoneda_domain =
                pythoneda-shared-pythonlang-domain;
              src = entrypointShTemplate;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              acmsl-licdata-artifact-events
              acmsl-licdata-iac-domain
              acmsl-licdata-iac-infrastructure
              pythoneda-shared-artifact-infrastructure
              pythoneda-shared-iac-events
              pythoneda-shared-pythonlang-banner
              pythoneda-shared-pythonlang-domain
              pythoneda-shared-pythonlang-application
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod -R +w $sourceRoot
              cp ${pyprojectToml} $sourceRoot/pyproject.toml
              cp ${bannerPy} $sourceRoot/${banner_file}
              cp ${entrypointSh} $sourceRoot/entrypoint.sh
            '';

            postPatch = ''
              substituteInPlace /build/$sourceRoot/entrypoint.sh \
                --replace "@SOURCE@" "$out/bin/${entrypoint}.sh" \
                --replace "@PYTHONEDA_EXTRA_NAMESPACES@" "org" \
                --replace "@PYTHONPATH@" "$PYTHONPATH" \
                --replace "@CUSTOM_CONTENT@" "" \
                --replace "@PYTHONEDA_SHARED_PYTHONLANG_DOMAIN@" "${pythoneda-shared-pythonlang-domain}" \
                --replace "@PACKAGE@" "$out/lib/python${pythonMajorMinorVersion}/site-packages" \
                --replace "@ENTRYPOINT@" "$out/lib/python${pythonMajorMinorVersion}/site-packages/${package}/${entrypoint}.py" \
                --replace "@PYTHON_ARGS@" "" \
                --replace "@BANNER@" "$out/bin/banner.sh"
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              cp /build/$sourceRoot/entrypoint.sh $out/bin/${entrypoint}.sh
              chmod +x $out/bin/${entrypoint}.sh
              echo '#!/usr/bin/env sh' > $out/bin/banner.sh
              echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/banner.sh
              echo "echo 'Running $out/bin/banner'" >> $out/bin/banner.sh
              echo "pushd $out/lib/python${pythonMajorMinorVersion}/site-packages" >> $out/bin/banner.sh
              echo "${python}/bin/python ${banner_file} \$@" >> $out/bin/banner.sh
              echo "popd" >> $out/bin/banner.sh
              chmod +x $out/bin/banner.sh
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        apps = rec {
          default = acmsl-licdata-iac-application-python311;
          acmsl-licdata-iac-application-python39 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-iac-application-python39;
            inherit entrypoint;
          };
          acmsl-licdata-iac-application-python310 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-iac-application-python310;
            inherit entrypoint;
          };
          acmsl-licdata-iac-application-python311 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-iac-application-python311;
            inherit entrypoint;
          };
          acmsl-licdata-iac-application-python312 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-iac-application-python312;
            inherit entrypoint;
          };
          acmsl-licdata-iac-application-python313 = shared.app-for {
            package =
              self.packages.${system}.acmsl-licdata-iac-application-python313;
            inherit entrypoint;
          };
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default = acmsl-licdata-iac-application-python311;
          acmsl-licdata-iac-application-python39 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-application-python39}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-application-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-application-python310 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-application-python310}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-application-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-application-python311 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-application-python311}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-application-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-application-python312 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-application-python312}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-application-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-application-python313 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-application-python313}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-application-python313;
              python = pkgs.python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = acmsl-licdata-iac-application-python311;
          acmsl-licdata-iac-application-python39 =
            acmsl-licdata-application-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python39;
              acmsl-licdata-iac-domain = acmsl-licdata-iac-domain.packages.${system}.acmsl-licdata-iac-domain-python39;
              acmsl-licdata-iac-infrastructure = acmsl-licdata-iac-infrastructure.packages.${system}.acmsl-licdata-iac-infrastructure-python39;
              python = pkgs.python39;
              pythoneda-shared-artifact-infrastructure = pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python39;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python39;
            };
          acmsl-licdata-iac-application-python310 =
            acmsl-licdata-application-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python310;
              acmsl-licdata-iac-domain = acmsl-licdata-iac-domain.packages.${system}.acmsl-licdata-iac-domain-python310;
              acmsl-licdata-iac-infrastructure = acmsl-licdata-iac-infrastructure.packages.${system}.acmsl-licdata-iac-infrastructure-python310;
              python = pkgs.python310;
              pythoneda-shared-artifact-infrastructure = pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python310;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python310;
            };
          acmsl-licdata-iac-application-python311 =
            acmsl-licdata-application-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python311;
              acmsl-licdata-iac-domain = acmsl-licdata-iac-domain.packages.${system}.acmsl-licdata-iac-domain-python311;
              acmsl-licdata-iac-infrastructure = acmsl-licdata-iac-infrastructure.packages.${system}.acmsl-licdata-iac-infrastructure-python311;
              python = pkgs.python311;
              pythoneda-shared-artifact-infrastructure = pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python311;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python311;
            };
          acmsl-licdata-iac-application-python312 =
            acmsl-licdata-application-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python312;
              acmsl-licdata-iac-domain = acmsl-licdata-iac-domain.packages.${system}.acmsl-licdata-iac-domain-python312;
              acmsl-licdata-iac-infrastructure = acmsl-licdata-iac-infrastructure.packages.${system}.acmsl-licdata-iac-infrastructure-python312;
              python = pkgs.python312;
              pythoneda-shared-artifact-infrastructure = pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python312;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python312;
            };
          acmsl-licdata-iac-application-python313 =
            pythoneda-acmsl-licdata-application-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python313;
              acmsl-licdata-iac-domain = acmsl-licdata-iac-domain.packages.${system}.acmsl-licdata-iac-domain-python313;
              acmsl-licdata-iac-infrastructure = acmsl-licdata-iac-infrastructure.packages.${system}.acmsl-licdata-iac-infrastructure-python313;
              python = pkgs.python313;
              pythoneda-shared-artifact-infrastructure = pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python313;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python313;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python313;
            };
        };
      });
}
