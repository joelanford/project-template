package reconciler

import (
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
	"k8s.io/client-go/rest"
	"sigs.k8s.io/controller-runtime/pkg/envtest"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"
)

func TestReconciler(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Reconciler Suite")
}

var (
	testenv *envtest.Environment
	cfg     *rest.Config
)

var _ = BeforeSuite(func() {
	logf.SetLogger(zap.New(zap.WriteTo(GinkgoWriter), zap.UseDevMode(true)))
	testenv = &envtest.Environment{}

	var err error
	cfg, err = testenv.Start()
	Expect(err).NotTo(HaveOccurred())

	// Uncomment to install CRDs, if necessary.
	// _, err = envtest.InstallCRDs(cfg, envtest.CRDInstallOptions{Paths: []string{pathToCRDFilesOrDirectories})
	// Expect(err).To(BeNil())
})

var _ = AfterSuite(func() {
	Expect(testenv.Stop()).To(Succeed())
})
