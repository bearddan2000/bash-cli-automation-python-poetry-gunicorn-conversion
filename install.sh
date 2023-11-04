#! /bin/bash
function replace_first() {
  #statements
  local file=$1
  local old='5000'
  local new=$2

  perl -pi.bak -0 -e "s/${old}/${new}/" $file
  rm -f ${file}.bak
}

function port_replace() {
  local dir=$1
  local path=$2

  case $dir in
    *bottle-ssl* ) 
      replace_first $path "443" ;;
    *bottle* ) 
      replace_first $path "8000" ;;
    *cherrypy* ) 
      replace_first $path "8080" ;;
    *dash* ) 
      replace_first $path "8050" ;;
    *falcon* ) 
      replace_first $path "8000" ;;
    *fastapi* ) 
      replace_first $path "8000" ;;
    *flask-ssl* ) 
      replace_first $path "443" ;;
    *flask* ) 
      replace_first $path "5000" ;;
    *pyramid* ) 
      replace_first $path "6543" ;;
    *tornado* ) 
      replace_first $path "8000" ;;
  esac
}

for d in `ls -la | grep ^d | awk '{print $NF}' | egrep -v '^\.'`; do

  rm -f $d/install.sh

  case $d in 
    *cli* )
      cp .src/install-cli.sh $d/install.sh ;;
    *desktop* )
      cp .src/install-cli.sh $d/install.sh ;;
    *web* )
      cp .src/install-web.sh $d/install.sh ;;
  esac

  if [[ -e $d/Dockerfile ]]; then
    #statements
    rm -f $d/Dockerfile
    cp .src/Dockerfile $d
    port_replace $d $d/Dockerfile
  else
    rm -f $d/py-srv/Dockerfile
    cp .src/Dockerfile $d/py-srv
    port_replace $d $d/py-srv/Dockerfile
  fi

  if [[ -e $d/bin/requirements.txt ]]; then
    #statements
    cp .src/requirements.sh $d/bin
    echo "" >> $d/bin/requirements.txt
    echo "gunicorn" >> $d/bin/requirements.txt
    if [[ -e $d/bin/app.py ]]; then
      mv $d/bin/app.py $d/bin/main.py
    fi
  else
    #statements
    cp .src/requirements.sh $d/py-srv/bin
    echo "" >> $d/py-srv/bin/requirements.txt
    echo "gunicorn" >> $d/py-srv/bin/requirements.txt
    if [[ -e $d/py-svr/bin/app.py ]]; then
      mv $d/py-svr/bin/app.py $d/py-svr/bin/main.py
    fi
  fi
  python3 $PWD/.src/pybuild/pyall.py $PWD/$d
  ./folder.sh $d

done
