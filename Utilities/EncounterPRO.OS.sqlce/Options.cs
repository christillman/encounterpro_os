using System;
using System.Collections.Specialized;
using System.Text;

namespace EncounterPRO.OS
{
	class Options
	{
		StringCollection args;

		public string ConnectionString
		{
			get { return args[0]; }
		}
		public string SqlText
		{
			get
			{
				if (this.Input != null)
				{
					System.IO.StreamReader sr = new System.IO.StreamReader(this.Input);
					string text = sr.ReadToEnd();
					sr.Close();
					return text;
				}
				else
					return args[args.Count - 1];
			}
		}
		public bool Help
		{
			get
			{
				if (args.Contains("/?") || args.Contains("-?") || args.Contains("help"))
					return true;
				return false;
			}
		}
		public bool Verbose
		{
			get
			{
				if (args.Contains("-v"))
					return true;
				return false;
			}
		}
		public bool Xml
		{
			get
			{
				if (args.Contains("-xml"))
					return true;
				return false;
			}
		}
		public string Input
		{
			get
			{
				if (args.Contains("-i"))
				{
					int indexMinusI = args.IndexOf("-i");
					if (args.Count < indexMinusI + 2)
						return null;
					return args[args.IndexOf("-i") + 1];
				}
				return null;
			}
		}
		public string Output
		{
			get
			{
				if (args.Contains("-o"))
				{
					int indexMinusO = args.IndexOf("-o");
					if (args.Count < indexMinusO + 2)
						return null;
					return args[args.IndexOf("-o") + 1];
				}
				return null;
			}
		}

		public Options(string[] args)
		{
			this.args = new StringCollection();
			this.args.AddRange(args);
		}
	}
}
