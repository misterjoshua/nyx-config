# . ~/proj/nyx/scripts/bashrc.sh

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

alias idea="intellij-idea-ultimate"
