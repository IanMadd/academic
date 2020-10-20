serve: assets
	hugo server --buildDrafts --noHTTPCache --buildFuture

serve_ignore_vendor: assets
	hugo server --buildDrafts --noHTTPCache --buildFuture --ignoreVendor
