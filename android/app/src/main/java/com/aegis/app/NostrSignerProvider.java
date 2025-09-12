package com.aegis.app;

import com.nt4f04und.android_content_provider.AndroidContentProvider;
import org.jetbrains.annotations.NotNull;

/**
 * NIP-55 Content Provider for Nostr Signer Application using android_content_provider plugin
 * 
 * This provider allows other applications to query for public keys, sign events,
 * and perform NIP-04/NIP-44 encryption/decryption operations.
 */
public class NostrSignerProvider extends AndroidContentProvider {

    @NotNull
    @Override
    public String getAuthority() {
        return "com.aegis.app.GET_PUBLIC_KEY;com.aegis.app.SIGN_EVENT;com.aegis.app.NIP04_ENCRYPT;com.aegis.app.NIP04_DECRYPT;com.aegis.app.NIP44_ENCRYPT;com.aegis.app.NIP44_DECRYPT;com.aegis.app.DECRYPT_ZAP_EVENT";
    }

    @NotNull
    @Override
    public String getEntrypointName() {
        return "aegisSignerProviderEntrypoint";
    }
}
