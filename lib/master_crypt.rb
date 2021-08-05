require "master_crypt/version"
require "rbnacl"
require "base64"
require "digest"

class MasterCrypt
  class CryptoError < StandardError; end

  # Create a new MasterCrypt object with a master key which
  # is used in `master_key_encrypt` and `master_key_decrypt`
  #
  # @param [String] Master key
  #
  # @return [MasterCrypt] A MasterCrypt object with a stored master key
  def initialize(master_key)
    raise ArgumentError, "Master key must not be blank" if master_key.nil? || master_key.empty?
    @master_key = master_key
  end

  # Encrypts plaintext data with the master key and an optional
  # list of additional secret keys
  #
  # @param plaintext [String] Plaintext data to be encrypted
  # @param secret_keys [Array<String>] Optional list of
  # additional secret keys to be used for encrypting data
  #
  # @return [String] Base64 representation of encrypted data
  #
  # @raise [ArgumentError] When secret keys are missing or blank
  def master_key_encrypt(plaintext, secret_keys = [])
    self.class.encrypt(plaintext, [@master_key] + Array(secret_keys))
  end

  # Decrypts encrypted data with the master key
  #
  # @param encrypted_data [String] Base64 representation of encrypted data
  #
  # @return [String] Decrypted plaintext data
  #
  # @raise [MasterCrypt::CryptoError] When master key or encrypted data is invalid
  def master_key_decrypt(encrypted_data)
    self.class.decrypt(encrypted_data, @master_key)
  end

  class << self
    # Encrypts plaintext data with a list of secret keys
    #
    # @param plaintext [String] Plaintext data to be encrypted
    # @param secret_keys [Array<String>] A list of secret keys to be used for encrypting data
    #
    # @return [String] Base64 representation of encrypted data
    #
    # @raise [ArgumentError] When secret keys are missing or blank
    def encrypt(plaintext, secret_keys)
      raise ArgumentError, "At least 1 secret key is required" if !secret_keys.is_a?(Array) || secret_keys.empty?
      raise ArgumentError, "Secret keys must not be blank" unless secret_keys.select(&:empty?).empty?

      random_key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      # encrypt data with random_key
      box = RbNaCl::SimpleBox.from_secret_key(random_key)

      encrypted_data = box.encrypt(plaintext)
      encrypted_data64 = Base64.strict_encode64(encrypted_data)

      # encrypt random_kets with each secret
      encrypted_random_keys64 = secret_keys.collect do |secret|
        key = generate_key_from_secret(secret)
        box = RbNaCl::SimpleBox.from_secret_key(key)

        encrypted_random_key = box.encrypt(random_key)
        encrypted_random_key64 = Base64.strict_encode64(encrypted_random_key)
        encrypted_random_key64
      end
      # encrypted_data|encrypted_random_key1:encrypted_random_key2:...
      Base64.strict_encode64(encrypted_data64 + "|" + encrypted_random_keys64.join(":"))
    end

    # Decrypts encrypted data with a provided secret key
    #
    # @param encrypted_data [String] Base64 representation of encrypted data
    # @param secret_key [String] Secret key to be used to decrypt data
    #
    # @return [String] Decrypted plaintext data
    #
    # @raise [MasterCrypt::CryptoError] When secret key or encrypted data is invalid
    def decrypt(encrypted_data, secret_key)
      encrypted_data64, encrypted_random_keys64_joined = Base64.strict_decode64(encrypted_data).split("|", 2)

      encrypted_random_keys64 = encrypted_random_keys64_joined.split(":")
      key = find_key(encrypted_random_keys64, secret_key)

      box = RbNaCl::SimpleBox.from_secret_key(key)

      ciphertext = Base64.strict_decode64(encrypted_data64)
      box.decrypt(ciphertext).force_encoding(Encoding::UTF_8)
    rescue RbNaCl::CryptoError => e
      raise CryptoError, e.message
    end

    private

    def find_key(encrypted_random_keys64, secret)
      secret_key = generate_key_from_secret(secret)
      box = RbNaCl::SimpleBox.from_secret_key(secret_key)

      encrypted_random_keys64.each do |encrypted_random_key64|
        encrypted_random_key = Base64.strict_decode64(encrypted_random_key64)
        begin
          random_key = box.decrypt(encrypted_random_key)
          return random_key
        rescue RbNaCl::CryptoError
        end
      end
      raise CryptoError, "Invalid secret key '#{secret}'"
    end

    def generate_key_from_secret(secret)
      Digest::SHA2.hexdigest(secret)[0...32].force_encoding(Encoding::BINARY)
    end
  end
end
