import unittest
from check_ssl_expiration import check_ssl_expiration


class TestCheckSSLExpiration(unittest.TestCase):
    def test_valid_certificate(self):
        domain_name = "google.com"
        result = check_ssl_expiration(domain_name)
        self.assertTrue(result["is_valid"])
        self.assertGreater(result["days_until_expiration"], 0)
        self.assertEqual(result["domain_name"], domain_name)

    def test_expired_certificate(self):
        domain_name = "expired.badssl.com"
        result = check_ssl_expiration(domain_name)
        self.assertFalse(result["is_valid"])
        self.assertEqual(result["days_until_expiration"], 0)
        self.assertEqual(result["domain_name"], domain_name)

    def test_invalid_domain(self):
        domain_name = "nonexistent.example"
        result = check_ssl_expiration(domain_name)
        self.assertIsNone(result)


if __name__ == "__main__":
    unittest.main()
