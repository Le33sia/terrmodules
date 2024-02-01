<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

require 'vendor/autoload.php'; // Include the AWS SDK for PHP

use Aws\Sdk;

$sdk = new Sdk([
    'region' => 'us-west-2', // Replace with your desired AWS region
]);

// Specify the name of your secret in AWS Secrets Manager
$secretName = 'secret7';//5.11 changes

// Create a Secrets Manager client
$secretsManager = $sdk->createSecretsManager();

// Retrieve the secret value from AWS Secrets Manager
try {
    $result = $secretsManager->getSecretValue([
        'SecretId' => $secretName,
    ]);

    $secret = $result['SecretString'];
    $secretData = json_decode($secret, true);

    $host = $secretData['host'];  
    $username = $secretData['username'];
    $password = $secretData['password']; 
    $dbname = $secretData['dbname'];
   

    $db_conn = @mysqli_connect($host, $username, $password, $database);

    if (!$db_conn) {
        echo "DB Connection Status: Failed";
    } else {
        echo "DB Connection Status: Successful";
    }
// Hostname of the instance
    echo "<br>";
    echo "Hostname: " . gethostname();
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>