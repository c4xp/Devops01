<?php

use Imbo\BehatApiExtension\Context\ApiClientAwareContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Tester\Exception\PendingException;
use Imbo\BehatApiExtension\Exception\AssertionFailedException as Failure;
use GuzzleHttp\ClientInterface;

use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Behat\Hook\Scope\AfterScenarioScope;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements ApiClientAwareContext 
{
    private $client;
    private $environment;
    private $ApiContext;

    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct() {
    }

    public function setClient(ClientInterface $client) {
        $this->client = $client;
    }

    /**
     * @BeforeScenario
     */
    public function gatherContexts(BeforeScenarioScope $scope) {
        $this->environment = $scope->getEnvironment();
        $this->ApiContext = $this->environment->getContext('Imbo\\BehatApiExtension\\Context\\ApiContext');
    }

    /**
     * @BeforeSuite
     */
    public static function prepare($scope) {
        //include_once('demox'.DIRECTORY_SEPARATOR.'cfg.php');
        //include_once(APP_DIR.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR.'db.class.php');
        //DB::connect(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'));
    }

    /**
     * @AfterSuite
     */
    public static function teardown($scope) {
        //include_once('demox'.DIRECTORY_SEPARATOR.'cfg.php');
        //include_once(APP_DIR.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR.'db.class.php');
        //DB::connect(getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASSWORD'), getenv('DB_NAME'));
    }
}