# encoding: UTF-8

require 'spec_helper'


module DICOMNET

  describe "Logger" do

    it "should be able to log to a file" do
      DICOMNET.logger = Logger.new(LOGDIR + 'logfile1.log')
      DICOMNET.logger.info("test")
      expect(File.open(LOGDIR + 'logfile1.log').readlines.last).to match(/INFO.*test/)
    end

    it "should be able to change the logging level" do
      expect(DICOMNET.logger.level).to eq(Logger::DEBUG)
      DICOMNET.logger.level = Logger::FATAL
      expect(DICOMNET.logger.level).to eq(Logger::FATAL)
    end

    it "should always say DICOMNET (for progname) when used within the DICOMNET module" do
      DICOMNET.logger = Logger.new(LOGDIR + 'logfile2.log')
      DICOMNET.logger.info("test")
      expect(File.open(LOGDIR + 'logfile2.log').readlines.last).to match(/DICOMNET:.*test/)
    end

    it "should use MARK (for progname) if I explicitly tell it to" do
      DICOMNET.logger = Logger.new(LOGDIR + 'logfile3.log')
      DICOMNET.logger.info("MARK") { "test" }
      expect(File.open(LOGDIR + 'logfile3.log').readlines.last).to match(/MARK:.*test/)
    end

    it "should use progname DICOMNET and MARK depending on where it was called" do
      logger = Logger.new(LOGDIR + 'logfile4.log')
      logger.progname = "MARK"
      DICOMNET.logger = logger
      DICOMNET.logger.info("test")
      expect(File.open(LOGDIR + 'logfile4.log').readlines.last).to match(/DICOMNET:.*test/)
      logger.info("test")
      expect(File.open(LOGDIR + 'logfile4.log').readlines.last).to match(/MARK:.*test/)
    end

    it "should be a class of ProxyLogger inside the DICOMNET module and Logger outside" do
      logger = Logger.new(LOGDIR + 'logfile5.log')
      DICOMNET.logger = logger
      expect(DICOMNET.logger.class).to eq(Logging::ClassMethods::ProxyLogger)
      expect(logger.class).to eq(Logger)
    end

    it "should not print messages when a non-verbose mode has been set (Logger::FATAL)" do
      DICOMNET.logger = Logger.new(LOGDIR + 'logfile6.log')
      DICOMNET.logger.level = Logger::FATAL
      DICOMNET.logger.debug("Debugging")
      DICOMNET.logger.info("Information")
      DICOMNET.logger.warn("Warning")
      DICOMNET.logger.error("Errors")
      expect(File.open(LOGDIR + 'logfile6.log').readlines.last.include?('DICOMNET')).to be_false
    end

    it "should print messages when a verbose mode has been set (Logger::DEBUG)" do
      DICOMNET.logger = Logger.new(LOGDIR + 'logfile7.log')
      DICOMNET.logger.level = Logger::DEBUG
      DICOMNET.logger.debug("Debugging")
      DICOMNET.logger.info("Information")
      DICOMNET.logger.warn("Warning")
      DICOMNET.logger.error("Errors")
      expect(File.open(LOGDIR + 'logfile7.log').readlines.last.include?('DICOMNET')).to be_true
    end

  end

end
