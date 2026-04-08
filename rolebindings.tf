#----- Create the cluster role and binding for writers
resource "kubernetes_cluster_role" "writers_role" {
    metadata {
        name = "cluster-writers"
    }
    rule {
            api_groups = [ "" ]
            resources = [
                    "nodes"                                  
                ]
            verbs = [ "get","list","watch" ]
    }
    rule {
            api_groups = [ "" ]
            resources = [
                    "configmaps",
                    "pods",
                    "namespaces",
                    "secrets",
                    "services"                                                 
                ]
            verbs = [ "create","get", "list", "watch","delete", "patch", "update"]
        }
    rule {
            api_groups = [ "" ]
            resources = [                                        
                    "endpoints",
                    "events",
                    "limitranges",                    
                    "pods/log",
                    "pods/exec",                
                    "podtemplates",
                    "replicationcontrollers",
                    "resourcequotas",             
                    "serviceaccounts"
                    
            ]
            verbs = [ "get", "list", "watch","delete", "patch", "update"]
    }
    rule {
            api_groups = [ "apps" ]
            resources = [                     
                    "daemonsets",
                    "deployments",
                    "replicasets",
                    "statefulsets"                
                ]
            verbs = [ "create","get", "list", "watch","patch","update","delete" ]
    }
       rule {
            api_groups = [ "autoscaling" ]
            resources = [ "horizontalpodautoscalers" ]                               
            verbs = [ "get", "list","watch","patch","update","delete" ]
    }
    rule {
            api_groups = [ "batch" ]
            resources = [ "cronjobs","jobs" ]
            verbs = [ "get","list", "watch","patch","update","delete" ]
    }
    rule {
            api_groups = [ "networking.k8s.io" ]
            resources = [ "ingressclasses","ingresses" ]
            verbs = [  "get", "list", "watch","patch","update","delete"]
    }
    rule {
            api_groups = [ "rbac.authorization.k8s.io" ]
            resources = [ "clusterrolebindings", "clusterroles", "rolebindings","roles" ]
            verbs = [  "get", "list", "watch","patch","update","delete"]
    }
     rule {
            api_groups = [ "metrics.k8s.io" ]
            resources = [ "nodes", "pods" ]
            verbs = [  "get", "list"]
    }
   rule {
            api_groups = [ "policy" ]
            resources = [ "poddisruptionbudgets"]
            verbs = [  "get", "list","watch","patch","update","delete"]
    }
      rule {
            api_groups = [ "aadpodidentity.k8s.io" ]
            resources = [ "azureassignedidentities", "azureidentities","azureidentitybindings","azurepodidentityexceptions" ]
            verbs = [  "get","list","watch","patch","update","delete"]
    }

}
resource "kubernetes_cluster_role_binding" "writers_role_binding" {     
    # Make sure this isn't created if no group ids are defined
    # This is necessary since the dynamic nested object below will not properly catch an empty list
    #count = length(var.cluster_writer_group_ids) == 0 ? 0 : 1

    metadata {
        name = "cluster-writers"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "cluster-writers"
    }

    
    subject {
        api_group = "rbac.authorization.k8s.io"
        kind = "Group"
        name = var.adgroups.writergrp
        #added below line temp to side step a bug
        #namespace = ""

    }
}

#----- Create the cluster role and binding for readers
resource "kubernetes_cluster_role" "readers_role" {
    metadata {
            name = "k8s-cluster-reader"
    }
    rule {
            api_groups = [ "" ]
            resources = [
                    "configmaps",                    
                    "endpoints",
                    "events",
                    "limitranges", 
                    "nodes",                      
                    "pods/log",
                    "pods/exec",                
                    "podtemplates",
                    "pods",
                    "namespaces",
                    "secrets",
                    "services", 
                    "replicationcontrollers",
                    "resourcequotas",             
                    "serviceaccounts"
                    
            ]
            verbs = [ "get", "list", "watch" ]
    }
    rule {
            api_groups = [ "apps" ]
            resources = [                     
                    "daemonsets",
                    "deployments",
                    "replicasets",
                    "statefulsets"                
                ]
            verbs = [ "get","list", "watch" ]
    }
       rule {
            api_groups = [ "autoscaling" ]
            resources = [ "horizontalpodautoscalers" ]                               
            verbs = [ "get","list","watch" ]
    }
    rule {
            api_groups = [ "batch" ]
            resources = [ "cronjobs","jobs" ]
            verbs = [ "get","list","watch" ]
    }
    rule {
            api_groups = [ "networking.k8s.io" ]
            resources = [ "ingressclasses","ingresses" ]
            verbs = [  "get","list", "watch"]
    }
    rule {
            api_groups = [ "rbac.authorization.k8s.io" ]
            resources = [ "clusterrolebindings", "clusterroles", "rolebindings","roles" ]
            verbs = [ "get","list", "watch"]
    }
     rule {
            api_groups = [ "metrics.k8s.io" ]
            resources = [ "nodes", "pods" ]
            verbs = [  "get", "list"]
    }
     rule {
            api_groups = [ "policy" ]
            resources = [ "poddisruptionbudgets"]
            verbs = [  "get", "list","watch"]
    }
   rule {
            api_groups = [ "aadpodidentity.k8s.io" ]
            resources = [ "azureassignedidentities", "azureidentities","azureidentitybindings","azurepodidentityexceptions" ]
            verbs = [  "get","list","watch"]
    }
}

resource "kubernetes_cluster_role_binding" "readers_role_binding" {
    # Make sure this isn't created if no group ids are defined
    # This is necessary since the dynamic nested object below will not properly catch an empty list
    #count = length(var.cluster_reader_group_ids) == 0 ? 0 : 1

    metadata {
            name = "k8s-cluster-reader-binding"
    }

    role_ref {
            api_group = "rbac.authorization.k8s.io"
            kind = "ClusterRole"
            name = "k8s-cluster-reader"
    }

    subject {
        api_group = "rbac.authorization.k8s.io"
        kind = "Group"
        name = var.adgroups.readergrp
        #added below line temp to side step a bug
        #namespace = ""
    }
}

resource "kubernetes_cluster_role" "pod-admin-role" {
    metadata {
        name = "cluster-pod-admin-role"
    }
    rule {
            api_groups = [ "" ]
            resources = [
                    "pods"                                  
                ]
           verbs=["create","get","list","deletecollection","watch","delete","patch","update"]
    }
}
resource "kubernetes_cluster_role_binding" "pod-admin-rolebinding" {
    metadata {
            name = "k8s-cluster-pod-admin-rolebinding"
    }

    role_ref {
            api_group = "rbac.authorization.k8s.io"
            kind = "ClusterRole"
            name = "cluster-pod-admin-role"
    }

    subject {
        api_group = "rbac.authorization.k8s.io"
        kind = "Group"
        name = var.adgroups.podadmgrp
        #added below line temp to side step a bug
        #namespace = ""

    }
}
# ----- Create the cluster role and binding for pim admins
resource "kubernetes_cluster_role" "pim_admin_role" {
    metadata {
        name = "pim_cluster-admin"
    }
    rule {
            api_groups = [ "*" ]
            resources = [ "*" ]
            verbs = [ "*" ]
    }
}


resource "kubernetes_cluster_role_binding" "pim_admin_role_binding" {     
    # Make sure this isn't created if no group ids are defined
    # This is necessary since the dynamic nested object below will not properly catch an empty list
    #count = length(var.cluster_writer_group_ids) == 0 ? 0 : 1

    metadata {
        name = "pim_cluster-admin-rolebinding"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "pim_cluster-admin"
    }

    
    subject {
        api_group = "rbac.authorization.k8s.io"
        kind = "Group"
        name = var.adgroups.pimadmingrp
        #added below line temp to side step a bug
        #namespace = ""

    }
}