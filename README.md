# master-crypt

## Usage

### Encrypting data with a master key
```ruby
master_key = "Very secure & random master k3y"
other_secret_key = "Another very secure & random master k3y"
plaintext = "Secret data..."
master_crypt = MasterCrypt.new(master_key)

encrypted_data = master_crypt.master_key_encrypt(plaintext, [other_secret_key])
# encrypted_data can be decrypted with either the master_key or other_secret_key
```

### Decrypting data with a master key
```ruby
master_key = "Very secure & random master k3y"
encrypted_data = "...."
master_crypt = MasterCrypt.new(master_key)

plaintext = master_crypt.master_key_decrypt(encrypted_data)
```

### Encrypting data with an array of keys

```ruby
secret_keys = ["array", "of", "secret", "keys"]
encrypted_data = MasterCrypt.encrypt(plaintext, secret_keys)
```

### Decrypting data with a specific key

```ruby
MasterCrypt.decrypt(encrypted_data, secret_keys[0])
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
