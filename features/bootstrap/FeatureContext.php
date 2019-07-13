<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

/**
 * Defines application features from the specific context.
 */
class FeatureContext implements Context
{
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

    
    /**
     * @Given I browse the site
     */
    public function iBrowseTheSite()
    {
        throw new PendingException();
    }

    /**
     * @Given I am tired
     */
    public function iAmTired()
    {
        throw new PendingException();
    }

    /**
     * @When that I am logged In
     */
    public function thatIAmLoggedIn()
    {
        throw new PendingException();
    }
}
