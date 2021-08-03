# master-crypt

## Usage

### Encrypting data with a master key
```ruby
master_key = "Very secure & random master k3y"
other_secret_key = "Another very secure & random other k3y"
data = "Secret data..."
master_crypt = MasterCrypt.new(master_key)

encrypted_data = master_crypt.master_key_encrypt(data, [other_secret_key])
# encrypted_data can be decrypted with either the master_key or other_secret_key
```

### Decrypting data with a master key
```ruby
master_key = "Very secure & random master k3y"
encrypted_data = "...."
master_crypt = MasterCrypt.new(master_key)

plaintext = master_crypt.master_key_decrypt(encrypted_data)
```

## Development
```sh
bundle install
```

## Specs

### Run all specs + standardrb

```sh
bundle exec rake
```

### Run specs using guard

```sh
bundle exec guard
```
