package e2e

import (
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/client-go/rest"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

var (
	cfg *rest.Config
	c   client.Client
)

func TestE2E(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "E2E Suite")
}

var _ = BeforeSuite(func() {
	var err error

	cfg, err = ctrl.GetConfig()
	Expect(err).To(BeNil())

	scheme := runtime.NewScheme()

	c, err = client.New(cfg, client.Options{Scheme: scheme})
	Expect(err).To(BeNil())
})
