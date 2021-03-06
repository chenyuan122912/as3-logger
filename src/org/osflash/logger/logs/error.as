package org.osflash.logger.logs
{
	import org.osflash.logger.LogFactory;
	import org.osflash.logger.logger_namespace;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public function error(...args) : void
	{
		use namespace logger_namespace;
		LogFactory.DEFAULT_LOGGER.error.apply(null, args);
	}
}
