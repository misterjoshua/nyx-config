# . ~/proj/nyx/scripts/bashrc.sh

export M_CONTEXT=${M_CONTEXT:-SET_M_CONTEXT}
export GO111MODULE=on

# Connection string for a bastion server
function mbastionconnect() {
  IP=$(kubectl --context $M_CONTEXT -n bastion get svc -ojsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
  echo "root@$IP"
}

# Connect to the bastion
function mbastion() {
  ssh $(mbastionconnect)
}

# List the node names for this cluster.
function mnodes() {
  kubectl --context $M_CONTEXT get node -oname | sed 's#.*/##'
}

# Connect to a node
function mnode() {
  NODE_NUMBER=${1:="0"}
  NODE_NAME=$(mnodes | grep -- "-$NODE_NUMBER\$")
  shift 1

  if [ ! -z "$NODE_NAME" ]; then
    echo "Connecting to $NODE_NAME"
    ssh -tA $(mbastionconnect) ssh -t azureuser@$NODE_NAME $*
  else
    echo "Available nodes are:"
    mnodes
  fi
}

# Switch to the M cluster context
function mcontext() {
  kubectl config use-context $M_CONTEXT
}

# Switch to the local cluster context
function lcontext() {
  kubectl config use-context microk8s
}

# Edit the bashrc
function vibashrc() {
  pushd .
  cd ~/proj/nyx
  code ~/proj/nyx
}

# Portworx cli
function pxctl() {
  if [ -z "$PX_POD" ]; then
    export PX_POD=$(kubectl -n kube-system get pods -lname=portworx -oname | shuf -n1)
  fi

  kubectl -n kube-system exec $PX_POD -- /opt/pwx/bin/pxctl $*
}

alias resticproj='restic -r ~/.restic/proj'
alias idea="intellij-idea-ultimate"
alias k="kubectl"

# Go bin
if [ -d "$HOME/go/bin" ]; then
  PATH=$PATH:$HOME/go/bin
fi

# Python user bin
if [ -d "$HOME/.local/bin" ]; then
  PATH=$PATH:$HOME/.local/bin
fi

# Composer user bin
if [ -d "$HOME/.config/composer/vendor/bin" ]; then
  PATH=$PATH:$HOME/.config/composer/vendor/bin
fi

if [ -x "$(command -v aws_completer)" ]; then
  complete -C "aws_completer" aws
fi

if [ -x "$(command -v operator-sdk)" ]; then
  # Operator SDK completion
  source <(operator-sdk completion bash)
fi

# Kubectl completion
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion bash)
fi

if [ -x "$(command -v helm)" ]; then
  # Helm completion
  source <(helm completion bash)
fi
