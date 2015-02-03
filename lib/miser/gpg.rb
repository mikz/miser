require 'shellwords'
require 'open3'

module Miser
  class GPG
    def initialize
      @private_key_file = Tempfile.new('private')
      @public_key_file = Tempfile.new('public')
    end

    def cmd
      @cmd ||= begin
        cmd = %w[gpg --no-default-keyring]
        cmd <<  '--secret-keyring' << @private_key_file.path
        cmd <<  '--keyring' << @public_key_file.path
      end
    end

    def batch_script(**options)
      key_length = ENV.fetch('MISER_KEY_LENGTH') { 2048 }
      general = {
        'Key-Type' => 'DSA',
        'Key-Length' => key_length,
        'Subkey-Type' => 'ELG-E',
        'Subkey-Length' => key_length,
        'Name-Real' => 'Miser Encryption Key',
        'Expire-Date' => '10y'
      }.merge(options)

      script = general.reject{|_k,v| v.to_s.empty? }.map {|line| line.compact.join(': ') }

      control = {
          pubring:  @public_key_file.path,
          secring: @private_key_file.path
      }

      script.concat control.map{|line| "%#{line.compact.join(' ')}" }
      script.join("\n")
    end

    def generate(passphrase: nil)
      script = batch_script(Passphrase: passphrase)
      _stdout, status = Open3.capture2('gpg', '--gen-key', '--batch', stdin_data: script)
      status.success?
    end

    def public_key
      @public_key ||= begin
        pubkey, status = Open3.capture2(*cmd, '-a', '--export')
        pubkey.strip if status.success?
      end
    end

    def private_key
      @private ||= begin
        key, status = Open3.capture2(*cmd, '-a', '--export-secret-keys')
        key.strip if status.success?
      end
    end
  end
end
