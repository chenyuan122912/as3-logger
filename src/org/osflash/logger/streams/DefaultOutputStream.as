package org.osflash.logger.streams
{
	import org.osflash.logger.ILogOutput;
	import org.osflash.logger.ILogOutputStream;
	import org.osflash.logger.LogLevel;
	import org.osflash.logger.LogTag;
	/**
	 * @author Simon Richardson - me@simonrichardson.info
	 */
	public class DefaultOutputStream implements ILogOutputStream
	{
		
		/**
		 * @private
		 */
		private var _outputs : Vector.<ILogOutput>;
		
		/**
		 * @private
		 */
		private var _filters : Vector.<LogTag>;
		
		/**
		 * @private
		 */
		private var _enabled : Boolean;
		
		/**
		 * Constructor for the LogOutputStream
		 */
		public function DefaultOutputStream()
		{
			_filters = new Vector.<LogTag>();
			_outputs = new Vector.<ILogOutput>();
			
			_enabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(output : ILogOutput) : ILogOutput
		{
			if(_outputs.indexOf(output) >= 0)
				throw new ArgumentError('Output already exists');
			
			_outputs.push(output);
			
			return output;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(output : ILogOutput) : ILogOutput
		{
			const index : int = _outputs.indexOf(output);
			if(index == -1)
				throw new ArgumentError('No such formatter exists');
			
			_outputs.splice(index, 1);
			
			return output;
		}

		/**
		 * @inheritDoc
		 */
		public function contains(output : ILogOutput) : Boolean
		{
			return _outputs.indexOf(output) >= 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAt(index : int) : ILogOutput
		{
			if(index < 0 || index >= _outputs.length)
				throw new RangeError();
			
			return _outputs[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function filter(tag : LogTag) : void
		{
			if(_filters.indexOf(tag) == -1) _filters.push(tag);
		}
		
		/**
		 * @inheritDoc
		 */
		public function filterNot(tag : LogTag) : void
		{
			const index : int = _filters.indexOf(tag);
			if(index >= 0) _filters.splice(index, 1);
		}

		/**
		 * @inheritDoc
		 */
		public function write(tag : LogTag, level : LogLevel, message : String) : void
		{
			if(!enabled) return;
			
			// We don't want to show the tag, we could save it - depends on if people want the data?
			if(_filters.length > 0 && _filters.indexOf(tag) >= 0) return;
			
			const total : int = _outputs.length;
			for(var i : int = 0; i < total; i++)
			{
				const output : ILogOutput = _outputs[i];
				const outputMessage : String = output.process(message);
				output.log(tag, level, outputMessage);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled() : Boolean { return _enabled; }
		public function set enabled(value : Boolean) : void { _enabled = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get length() : int { return _outputs.length; }
	}
}
