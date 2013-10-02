# vim: ft=ruby
#
# Make sure to have Vagrant 1.3+ and that the vagrant-salt plugin is not
# installed:
#
# `vagrant plugins uninstall vagrant-salt`

Vagrant.configure("2") do |config|
  config.vm.box = 'ec2-precise64'
  config.vm.box_url = 'https://s3.amazonaws.com/mediacore-public/boxes/ec2-precise64.box'
  # http://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
  #config.vm.network "private_network", ip: "172.16.10.4"

  ## For local master, mount your file_roots
  config.vm.synced_folder "salt/roots/", "/srv/"

  config.vm.network "forwarded_port",
    guest: 80,
    host: 8080,
    auto_correct: true

  config.vm.provision :salt do |salt|
    # Config Options
    salt.minion_config = "salt/minion"
    salt.master_config = "salt/master"

    # These are more useful when connecting to a remote master
    # and you want to use pre-seeded keys (already accepted on master)
    ## !! Please do not use these keys in production!
    salt.minion_key = "salt/key/minion.pem"
    salt.minion_pub = "salt/key/minion.pub"

    # Good for multi-vm setups where live minions are expecting
    # existing master
    ## !! Please do not use these keys in production!
    salt.master_key = "salt/key/master.pem"
    salt.master_pub = "salt/key/master.pub"

    # Stable is 0.16.4 at the moment, which is outdated in many aspects
    salt.install_type = "stable"
    # If you need bleeding edge salt
    #salt.install_type = "git"
    #salt.install_args = "v0.17.0"
    #salt.install_args = "develop"

    # Install a master on this machine
    salt.install_master = true

    # Pre-seed your master (recommended)
    salt.seed_master = {minion: salt.minion_pub}

    # Can also install syndic:
    # salt.install_syndic = true

    # Minion is on by default, but can be disabled:
    # salt.no_minion = true

    # Actions
    # Normally we want to run state.highstate to provision the machine
    salt.run_highstate = true

    # Default will not install / update salt binaries if they are present
    # Use this option to always install
    # salt.always_install = true

    # Gives more output, such as from the bootstrap script
    salt.verbose = true
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]

    aws.region = ENV["AWS_REGION"] || "us-east-1"
    aws.instance_type = "t1.micro"
    aws.tags = {
      'Name' => 'salt-master'
    }
    # Make sure salt-master gives access to port TCP 4505
    aws.security_groups = ['default', 'salt-master']

    override.vm.hostname = 'salt-master'
    override.vm.box_url = 'https://s3.amazonaws.com/mediacore-public/boxes/ec2-precise64-aws.box'
    override.ssh.private_key_path = ENV["AWS_SSH_PRIVKEY"]
  end

  config.vm.provider :virtualbox do |_, override|
    override.vm.box_url = 'https://s3.amazonaws.com/mediacore-public/boxes/ec2-precise64.box'
  end
end
