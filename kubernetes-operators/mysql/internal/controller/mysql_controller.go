/*
Copyright 2024.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controller

import (
	"context"
	"fmt"

	otushomeworkv1 "mysql/api/v1"

	apps "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	rbac "k8s.io/api/rbac/v1"
	errors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/log"
)

// MySQLReconciler reconciles a MySQL object
type MySQLReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

const (
	APIGroupAll          = "*"
	ResourceAll          = "*"
	VerbAll              = "*"
	OperatorImage string = "23f03013e37f/otus-2023-12-mysql-operator:0.0.1"
)

//+kubebuilder:rbac:groups=otus.homework,resources=mysqls,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=otus.homework,resources=mysqls/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=otus.homework,resources=mysqls/finalizers,verbs=update

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the MySQL object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.17.0/pkg/reconcile
func (r *MySQLReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	_ = log.FromContext(ctx)

	// TODO(user): your logic here
	instance := &otushomeworkv1.MySQL{}
	instance.WithDefaults()
	err := r.Get(ctx, req.NamespacedName, instance)
	if err != nil {
		return ctrl.Result{}, err
	}
	fmt.Println(instance.Spec.Message)

	sa := &v1.ServiceAccount{
		ObjectMeta: metav1.ObjectMeta{
			Name:      instance.Spec.Name,
			Namespace: "default",
		},
	}

	if err := r.Create(ctx, sa); err != nil {
		if !errors.IsAlreadyExists(err) {
			return ctrl.Result{}, err
		}
	}

	clusterRole := &rbac.ClusterRole{
		ObjectMeta: metav1.ObjectMeta{
			Name: instance.Spec.Name,
		},
		Rules: []rbac.PolicyRule{
			{
				APIGroups: []string{APIGroupAll},
				Resources: []string{ResourceAll},
				Verbs:     []string{VerbAll},
			},
			{
				APIGroups: []string{""},
				Resources: []string{ResourceAll},
				Verbs:     []string{VerbAll},
			},
		},
	}

	if err := r.Create(ctx, clusterRole); err != nil {
		if !errors.IsAlreadyExists(err) {
			return ctrl.Result{}, err
		}
	}

	clusterRoleBinding := &rbac.ClusterRoleBinding{
		ObjectMeta: metav1.ObjectMeta{
			Name: instance.Spec.Name,
		},
		Subjects: []rbac.Subject{
			{
				Kind:      "ServiceAccount",
				Name:      instance.Spec.Name,
				Namespace: "default",
			},
		},
		RoleRef: rbac.RoleRef{
			Kind:     "ClusterRole",
			Name:     clusterRole.Name,
			APIGroup: "rbac.authorization.k8s.io",
		},
	}

	if err := r.Create(ctx, clusterRoleBinding); err != nil {
		if !errors.IsAlreadyExists(err) {
			return ctrl.Result{}, err
		}
	}

	/* 	pod := &v1.Pod{
		ObjectMeta: metav1.ObjectMeta{
			Name:      instance.ObjectMeta.Name,
			Namespace: "default",
		},
		Spec: v1.PodSpec{
			Containers: []v1.Container{
				{
					Name:  instance.ObjectMeta.Name,
					Image: instance.Spec.Image,
				},
			},
		},
	} */

	replicas := int32(1)
	podLabels := map[string]string{"app": "mysql-operator", "component": "homework"}

	deployment := &apps.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name:      instance.Spec.Name,
			Namespace: "default",
		},
		Spec: apps.DeploymentSpec{
			Replicas: &replicas,
			Selector: &metav1.LabelSelector{
				MatchLabels: podLabels,
			},
			Strategy: apps.DeploymentStrategy{
				Type: apps.RollingUpdateDeploymentStrategyType,
			},
			Template: v1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: podLabels,
				},
				Spec: v1.PodSpec{
					ServiceAccountName: sa.Name,
					Containers: []v1.Container{
						{
							Name:  instance.Spec.Name,
							Image: OperatorImage,
						},
					},
				},
			},
		},
	}

	if err := r.Create(ctx, deployment); err != nil {
		if !errors.IsAlreadyExists(err) {
			return ctrl.Result{}, err
		}
	}

	if errors.IsNotFound(r.Get(ctx, client.ObjectKey{Namespace: req.Namespace, Name: req.Name}, &apps.Deployment{})) {
		fmt.Println("Deleting Operator Deployment...")
		r.Delete(ctx, deployment)
		fmt.Println("Deleting ClusterRoleBinding...")
		r.Delete(ctx, clusterRoleBinding)
		fmt.Println("Deleting RoleBinding...")
		r.Delete(ctx, clusterRole)
		fmt.Println("Deleting ServiceAccount...")
		r.Delete(ctx, sa)
		return ctrl.Result{}, err
	}

	fmt.Println(ctrl.Result{}, nil)
	return ctrl.Result{}, nil

}

// SetupWithManager sets up the controller with the Manager.
func (r *MySQLReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&otushomeworkv1.MySQL{}).
		Complete(r)
}
