downloadname="alembic"
# package name
swname="alembic.io"
# package version
swver="1.7.11"

# build functions

__get_source_code() {
   [ -d "${swname}-${swver}-debian" ] || \
      die "no such folder: $PWD/${swname}-${swver}-debian"

   echo "** - removing the folder ${swname}-${swver} ..."
   rm -fr "${swname}-${swver}"

   dpkg -i ${outdir}/libilmbase24_2.3.0-5_amd64.deb
   dpkg -i ${outdir}/libilmbase-dev_2.3.0-5_amd64.deb
   dpkg -i ${outdir}/libopenexr24_2.3.0-5_amd64.deb
   dpkg -i ${outdir}/libopenexr-dev_2.3.0-5_amd64.deb

   echo "** - download the ${swname}  with tag v${downloadver} ..."
   wget https://github.com/${downloadname}/${downloadname}/archive/${swver}.tar.gz -O ${swname}_${swver}.orig.tar.gz

   tar -zxvf ${swname}_${swver}.orig.tar.gz
   mv ${downloadname}-${swver} ${swname}-${swver}
   [ -d "${swname}-${swver}" ] || \
      die "no such folder: $PWD/${swname}-${swver}"

   cp -pr "${swname}-${swver}-debian" \
          "${swname}-${swver}/debian"
   # change version with code name
   debian_name=$(lsb_release  -sc)
   #sed -i "s|{debian_name}|${debian_name}|g"  "${swname}-${swver}/debian/changelog"
   #echo ${debian_name}
}

__install_build_dependencies() {
   apt-get --quiet update \
      && DEBIAN_FRONTEND=noninteractive \
         apt-get install -y \
            bash-completion \
            python-all  \
            debhelper \
            autoconf-archive \
            dh-buildinfo \
            pkg-config \
            zlib1g-dev \
            libhdf5-dev \
            cmake \
            libboost-python-dev \
            libboost-program-options-dev \
            python-numpy \
            libboost-python1.62-dev \
      && dpkg -i ${outdir}/python-pyilmbase_2.3.0_all.deb \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /var/cache/apt/archives/* 
}

__build_source_code() {
   cd ${swname}-${swver}
   debuild -us -uc
}

__move_packages_to_outdir() {
   mv ../*.{build*,changes,deb,dsc} \
      ../${swname}_${swver}*.diff.gz \
      ../${swname}_${swver}.orig.tar.gz \
      ${outdir}/
}

__cleanall() {
   echo "** - removing temporary build folder ${buildir}/${swname}-${swver} ..."
   #rm -fr ${buildir}/${swname}-${swver}
   echo "** - removing sources folder ${swname}-${swver} ..."
   #rm -fr ${swname}-${swver}
}
