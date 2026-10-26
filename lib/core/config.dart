const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080/api',
);

const apiUser = String.fromEnvironment('API_USER', defaultValue: 'admin');

const apiPassword = String.fromEnvironment(
  'API_PASSWORD',
  defaultValue: 'admin123',
);
