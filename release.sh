#!/usr/bin/env bash
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
LOCALPATH=$GOPATH/src/k8s.io/kubernetes/
BINPATH=$GOPATH/src/k8s.io/kubernetes/_output/local/bin/linux/ppc64le

if [ $github_version != $ftp_version ]
then
  git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
  cd repository-scrips/
  chmod +x empacotar-deb.sh
  chmod +x empacotar-rpm.sh
  sudo mv empacotar-deb.sh $BINPATH
  sudo mv empacotar-rpm.sh $BINPATH
  cd $BINPATH
  sudo ./empacotar-deb.sh kubelet kubelet-$github_version $github_version " "
  sudo ./empacotar-rpm.sh kubelet kubelet-$github_version $github_version " " "kubelet: the component that runs on all of the machines in your cluster and does things like starting pods and containers"
  if [ $github_version > $ftp_version ]
  then
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/debian/ppc64el/tool-kubernete/ $BINPATH/kubelet-$github_version-ppc64le.deb"
    sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/rpm/ppc64le/tool-kubernete/ ~/rpmbuild/RPMS/ppc64le/kubelet-$github_version-1.ppc64le.rpm"
  fi
fi
